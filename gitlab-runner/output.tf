
output "runner_disk_size" {
    value = "${var.runner_disk_size}"
}

output "runner_image" {
    value = "${var.runner_image}"
}

output "gitlab_ci_runner_service_account" {
    value = "${google_service_account.gitlab-ci-runner.*.email}"
}