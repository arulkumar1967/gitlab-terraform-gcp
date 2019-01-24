
resource "null_resource" "gitlab-runner-bootstrap" {
    triggers {
        instance = "${google_compute_instance.gitlab-ci-runner.id}"
    }

    connection {
        host = "${google_compute_instance.gitlab-ci-runner.network_interface.0.access_config.0.assigned_nat_ip}"
        type = "ssh"
        user = "ubuntu"
        agent = "false"
        private_key = "${file("${var.ssh_key}")}"
    }

    provisioner "file" {
        source = "${path.module}/bootstrap_runner"
        destination = "/tmp/bootstrap_runner"
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x /tmp/bootstrap_runner",
          "sudo /tmp/bootstrap_runner ${google_compute_instance.gitlab-ci-runner.name} ${var.runner_host} ${var.runner_token} ${var.runner_image}"
        ]
    }

    provisioner "remote-exec" {
        when = "destroy"
        on_failure = "continue"
        inline = [
          "docker exec gitlab-runner unregister --name ${google_compute_instance.gitlab-ci-runner.name}"
        ]
    }
}

