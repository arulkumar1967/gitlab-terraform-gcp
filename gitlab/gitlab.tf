provider "google" {
    project = "${var.project}"
    region = "${var.region}"
}

resource "google_compute_network" "gitlab_network" {
    count = "${var.network != "default" ? 1 : 0}"
    description = "Network for GitLab instance"
    name = "${var.network}"
    auto_create_subnetworks = "true"
}

resource "random_id" "initial_root_password" {
    byte_length = 15
}

resource "random_id" "runner_token" {
    byte_length = 15
}

resource "google_compute_disk" "default" {
    count = "${var.deploy_gitlab ? 1 : 0}"
    name  = "${var.prefix}${var.instance_name}"
    type  = "pd-standard"
    zone  = "${var.zone}"
    image = "${var.image}"
    size  = "${var.data_size}"
    labels {
        environment = "dev"
    }
}

resource "google_compute_instance" "gitlab-ce" {
    count = "${var.deploy_gitlab ? 1 : 0}"
    name = "${var.prefix}${var.instance_name}"
    machine_type = "${var.machine_type}"
    zone = "${var.zone}"
    tags = ["gitlab"]

    boot_disk {
        auto_delete = false
        source = "${google_compute_disk.default.self_link}"
    }

    labels = {
        type = "${var.server_type}"
    }

    network_interface {
        network = "${var.network}"
        access_config {
            nat_ip = "${var.external_ip}"
        }
    }

    metadata {
        sshKeys = "ubuntu:${file("${var.ssh_key}.pub")}"
    }
}

resource "google_dns_record_set" "gitlab_instance" {
    count = "${var.dns_zone != "no_dns" ? 1 : 0}"
    name = "${var.dns_name}."
    type = "A"
    ttl = 300
    # TODO: This is really hard to read. I'd like to revisit at some point to clean it up.
    # But we shouldn't need two variables to specify DNS name
    managed_zone = "${var.dns_zone}"
    rrdatas = ["${google_compute_instance.gitlab-ce.network_interface.0.access_config.0.assigned_nat_ip}"]
}
