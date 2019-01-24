
variable "server_type" {
    description = "type of server."
    default = ""
}

variable "network" {
    description = "The network for the instance to live on"
    default = "default"
}

variable "external_ip" {
    description = "External IP of Gitlab-CE"
}

variable "gitlab_host" {
    description = "Host url of gitlab"
    default = "GENERATE"
}

variable "auth_file" {
    description = "The configuration file containing the credentials to connect to google"
    default = "/home/jayanthiarulkumar98/key.json"
}

variable "data_size" {
    description = "The size of the data volume to create in gigabytes"
    default = "30"
}

variable "data_volume" {
    description = "A storage volume for storing your GitLab data"
    default = "default"
}

variable "image" {
    description = "The image to use for the instance"
    default = "ubuntu-1604-xenial-v20170330"
}

variable "machine_type" {
    description = "A machine type for your compute instance"
    default = "n1-standard-1"
}

variable "region" {
    description = "The region this all lives in. TODO can this be inferred from zone or vice versa?"
    default = "eu-west2"
}

variable "zone" {
    description = "The zone to deploy the machine to"
    default = "eu-west2-c"
}

variable "data_volume_type" {
    description = "The type of volume to use for data"
    default = "pd-standard"
}

variable "instance_name" {
    description = "The name of the instance to use"
    default = "gitlab-instance"
}

variable "dns_name" {
    description = "The DNS name of the GitLab instance."
    default = "vpon.test.com"
}

variable "dns_zone" {
    description = "The name of the DNS zone in Google Cloud that the DNS name should go under"
    default = "no_dns"
}

variable "project" {
    description = "The project in Google Cloud to create the GitLab instance under"
}

variable "ssh_key" {
    description = "The ssh key to use to connect to the Google Cloud Instance"
    default = "~/.ssh/id_rsa"
}

variable "ssl_key" {
    description = "The SSL keyfile to use"
    default = "/dev/null"
}

variable "ssl_certificate" {
    description = "The SSL certificate file to use"
    default = "/dev/null"
}

variable "deploy_gitlab" {
    description = "Enable / Disable deploying a GitLab instance"
    default = false
}

variable "initial_root_password" {
    description = "Set the initial admin password, generated if not provided"
    default = "GENERATE"
}

variable "prefix" {
    description = "Prefix to resource names in cloud provider"
    default = ""
}

variable "generate_runner_service_account" {
    default = "true"
}

variable "runner_token" {
    description = "GitLab CI Runner registration token. Will be generated if not provided"
    default = "GENERATE"
}

data "template_file" "dt" {
    template = "$${dt}"
    vars {
        dt = "${substr(replace("${timestamp()}", "/\\D/", ""), 2, 10)}"
    }
}
