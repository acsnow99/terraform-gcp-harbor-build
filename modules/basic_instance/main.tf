# Create runner node
resource "google_compute_instance" "runner" {
    name = "${var.prefix}"
    machine_type = "${var.machine}"
    allow_stopping_for_update = "true"
    boot_disk {
         initialize_params {
             image =  "${var.image}"
         }
    }

    network_interface {
        network = "terraform-gcp-harbor"
        subnetwork = "harbor-repo-0"
        access_config {
            # nat_ip is here
        }
    }

    metadata = {
        ssh-keys = "alexsnow:${file("~/.ssh/id_rsa.pub")}"
    }
}

# installs Harbor and other necessary tools
resource "null_resource" "install-harbor" {
    connection {
            type = "ssh"
            host = "${google_compute_instance.runner.network_interface.0.access_config.0.nat_ip}"
            user = "alexsnow"
            private_key = "${file("~/.ssh/id_rsa")}"
    }
    provisioner "file" {
        source = "${var.commandfile}"
        destination = "/tmp/run-command.sh"
    }
    provisioner "file" {
        source = "~/terraform/gcp/harbor/harbor-instance/"
        destination = "~/terraform_harbor/"
    }
    provisioner "file" {
        source = "~/terraform/terraform_keys/terraform-gcp-harbor-80a453b96ca7.json"
        destination = "~/terraform_harbor/terraform_key.json"
    }
    provisioner "remote-exec" {
        inline = [
            # uses the file from the other provisioner to install docker and download harbor
            "sudo chmod 755 /tmp/run-command.sh",
            "sudo /tmp/run-command.sh",
        ]
    }
}