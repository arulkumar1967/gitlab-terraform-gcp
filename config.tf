
variable "project" {
    default = "terraformpoc-229221"
}

variable "generate_external_ip" {
    default = false
}

variable "source_ranges" {
    type = "list"
    default = ["0.0.0.0/0"]
}

variable "deploy_gitlab" {
    default = false
}

variable "runner_count" {
    default = 1
}

variable "runner_host" {
    default = "GENERATE"
}

data "template_file" "runner_host" {
    template = "$${runner_host == "GENERATE" ? generated_host : runner_host}"
    vars {
        runner_host = "${var.runner_host}"
        #generated_host = "http${var.ssl_certificate != "/dev/null" ? "s" : ""}://${var.dns_name}"
        generated_host = "http://${module.gitlabci.internal_ip}"
    }
}
