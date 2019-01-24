
variable "network" {
    description = "The network for the instance to live on"
    default = "default"
}

variable "ssh_key" {
    description = "The ssh key to use to connect to the Google Cloud Instance"
    default = "~/.ssh/id_rsa"
}

variable "image" {
    description = "The image to use for the instance"
    default = "ubuntu-1604-xenial-v20170330"
}

variable "region" {
    description = "The region this all lives in. TODO can this be inferred from zone or vice versa?"
    default = "eu-west2"
}

variable "zone" {
    description = "The zone to deploy the machine to"
    default = "eu-west2-c"
}

variable "project" {
    description = "The project in Google Cloud to create the GitLab instance under"
}

variable "prefix" {
    description = "Prefix to resource names in cloud provider"
    default = ""
}

variable "generate_runner_service_account" {
    default = "true"
}

variable "runner_count" {
    description = "Number of GitLab CI Runners to create."
}

variable "runner_host" {
    description = "URL of the GitLab server Runner will register with"
}

variable "runner_token" {
    description = "GitLab CI Runner registration token. Will be generated if not provided"
}

variable "runner_disk_size" {
    description = "Size of disk (in GB) for Runner instances"
    default = 20
}

variable "runner_image" {
    description = "The Docker image a GitLab CI Runner will use by default"
    default = "docker:latest"
}

variable "runner_machine_type" {
    description = "A machine type for your compute instance, used by GitLab CI Runner"
    default = "n1-standard-1"
}

data "template_file" "dt" {
    template = "$${dt}"
    vars {
        dt = "${substr(replace("${timestamp()}", "/\\D/", ""), 2, 10)}"
    }
}