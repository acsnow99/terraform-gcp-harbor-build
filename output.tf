output "instance-ip" {
    value = "${module.harbor-runner-instance.public_ip}"
}

output "machine-name" {
    value = "${var.prefix}"
}