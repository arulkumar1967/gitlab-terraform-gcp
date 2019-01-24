provider "google" {
    project = "${var.project}"
    region = "${var.region}"
}

resource "google_compute_firewall" "external_ports_ssl" {
    count = "${var.ssl_certificate != "/dev/null" ? 1 : 0}"
    name = "${var.prefix}${var.external_ports_name}"
    network = "${var.network}"
    target_tags = ["${var.prefix}${var.external_ports_name}"]
    source_ranges = "${var.source_ranges}"

    allow {
        protocol = "tcp"
        ports = "${var.public_ports_ssl}"
    }
}

resource "google_compute_firewall" "external_ports_no_ssl" {
    count = "${var.ssl_certificate != "/dev/null" ? 0 : 1}"
    name = "${var.prefix}${var.external_ports_name}"
    network = "${var.network}"
    target_tags = ["${var.prefix}${var.external_ports_name}"]
    source_ranges = "${var.source_ranges}"

    allow {
        protocol = "tcp"
        ports = "${var.public_ports_no_ssl}"
    }
}

resource "google_compute_address" "external_ip" {
    count = "${var.generate_external_ip ? 1 : 0}"
    name = "${var.prefix}${var.external_address_name}"
    region = "${var.region}"
}

data "google_compute_address" "external_ip" {
    count = "${var.generate_external_ip == false ? 1 : 0}"
    name = "${var.prefix}${var.external_address_name}"
}

data "template_file" "external_ip" {
    template = "$${generate_external_ip ? generated_ip : exist_ip}"
    vars {
        generate_external_ip = "${var.generate_external_ip}"
        generated_ip         = "${element(concat(google_compute_address.external_ip.*.address, list("")), 0)}"
        exist_ip             = "${element(concat(data.google_compute_address.external_ip.*.address, list("")), 0)}"
    }
}
