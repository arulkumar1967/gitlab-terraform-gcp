
output "address" {
    value = "${data.template_file.external_ip.rendered}"
}
