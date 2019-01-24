# provider google in main.tf
# resource google_compute_network gitlab_network in main.tf

provider "google" {
    project = "${var.project}"
    region = "${var.region}"
}

resource "google_service_account" "gitlab-ci-runner" {
    account_id   = "gitlab-ci-runner"
    display_name = "gitlab-ci-runner"
}

resource "google_compute_instance" "gitlab-ci-runner" {
    count = "${var.runner_count}"
    name = "${var.prefix}gitlab-ci-runner-${count.index}"
    machine_type = "${var.runner_machine_type}"
    zone = "${var.zone}"

    tags = ["gitlab-ci-runner"]

    network_interface {
        network = "${var.network}"
        access_config {
          // Ephemeral IP
        }
    }

    allow_stopping_for_update = true

    metadata {
        sshKeys = "ubuntu:${file("${var.ssh_key}.pub")}"
    }

    boot_disk {
        auto_delete = true
        initialize_params = {
            image = "${var.image}"
            size  = "${var.runner_disk_size}"
        }
    }

    scheduling {
        preemptible = true
        automatic_restart = false
    }

    service_account {
        email = "${google_service_account.gitlab-ci-runner.email}"
        scopes = ["cloud-platform"]
    }
}

