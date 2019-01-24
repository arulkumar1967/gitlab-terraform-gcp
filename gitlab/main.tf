
data "template_file" "gitlab" {
    template = "${file("${path.module}/templates/gitlab.rb.append")}"

    vars {
        initial_root_password = "${var.initial_root_password != "GENERATE" ? var.initial_root_password : format("%s", random_id.initial_root_password.hex)}"
        runner_token = "${var.runner_token != "GENERATE" ? var.runner_token : format("%s", random_id.runner_token.hex)}"
        gitlab_host = "http://${var.gitlab_host != "GENERATE" ? var.gitlab_host : var.external_ip}"
    }
}

resource "null_resource" "gitlab-bootstrap" {
  count = "${var.deploy_gitlab ? 1 : 0}"
  triggers {
    instance = "${google_compute_instance.gitlab-ce.id}"
    template = "${data.template_file.gitlab.rendered}"
  }

  connection {
    host = "${google_compute_instance.gitlab-ce.network_interface.0.access_config.0.assigned_nat_ip}"
    type = "ssh"
    user = "ubuntu"
    agent = "false"
    private_key = "${file("${var.ssh_key}")}"
  }

  provisioner "file" {
    content = "${data.template_file.gitlab.rendered}"
    destination = "/tmp/gitlab.rb.append"
  }

  provisioner "file" {
    source = "${path.module}/templates/gitlab.rb"
    destination = "/tmp/gitlab.rb"
  }

  provisioner "file" {
    source = "${path.module}/bootstrap"
    destination = "/tmp/bootstrap"
  }

  provisioner "file" {
    source = "${var.ssl_key}"
    destination = "/tmp/ssl_key"
  }

  provisioner "file" {
    source = "${var.ssl_certificate}"
    destination = "/tmp/ssl_certificate"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /tmp/gitlab.rb.append >> /tmp/gitlab.rb",
      "chmod +x /tmp/bootstrap",
      "sudo /tmp/bootstrap ${var.dns_name}"
    ]
  }
}
