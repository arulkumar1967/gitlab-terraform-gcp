terraform {
  backend "gcs" {
    bucket = "arul_terraform_states"
    prefix = "gitlab/gitlab.tfstate"
    credentials = "/home/jayanthiarulkumar98/key.json"
  }
}

module "gitlabci" {
  source = "./gitlab"
  project = "${var.project}"
  external_ip = "${module.network.address}"
  deploy_gitlab = "${var.deploy_gitlab}"
}

module "network" {
  source = "./network"
  project = "${var.project}"
  source_ranges = "${var.source_ranges}"
  external_address_name = "gitlab-ce-enternal-ip"
  generate_external_ip = "${var.generate_external_ip}"
}

module "gitlab-runner" {
  source = "./gitlab-runner"
  runner_count = "${var.runner_count}"
  project = "${var.project}"
  runner_host = "${data.template_file.runner_host.rendered}"
  runner_token = "${module.gitlabci.runner_token}"
}
