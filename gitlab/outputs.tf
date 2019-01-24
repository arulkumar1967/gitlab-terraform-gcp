
output "address" {
    value = "${google_compute_instance.gitlab-ce.network_interface.0.access_config.0.assigned_nat_ip}"
}

output "internal_ip" {
    value = "${google_compute_instance.gitlab-ce.network_interface.0.address}"
}

output "initial_root_password" {
    value = "${random_id.initial_root_password.hex}"
}

output "runner_token" {
    value = "${random_id.runner_token.hex}"
}

