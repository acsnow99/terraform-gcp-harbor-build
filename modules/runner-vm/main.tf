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
        network = "${var.network}"
        subnetwork = "${var.subnet}"
        access_config {
            # nat_ip is here
        }
    }

    metadata = {
        ssh-keys = "alexsnow:${file("~/.ssh/id_rsa.pub")}"
    }
}

# provisions the runner vm with necessary scripts but does not run them
resource "null_resource" "ready-for-install" {
    count = "${var.layer-1}"
    connection {
            type = "ssh"
            host = "${google_compute_instance.runner.network_interface.0.access_config.0.nat_ip}"
            user = "alexsnow"
            private_key = "${file("~/.ssh/id_rsa")}"
    }
    provisioner "file" {
        source = "${var.commandfile}"
        destination = "~/run-command.sh"
    }
    provisioner "file" {
        source = "~/terraform/terraform_keys/terraform-gcp-harbor-80a453b96ca7.json"
        destination = "~/terraform_key.json"
    }
    provisioner "remote-exec" {
        inline = [
            # file must be run through ssh later
            "sudo chmod 755 ~/run-command.sh",
            "mkdir ~/terraform_harbor",
            "mv ~/terraform_key.json ~/terraform_harbor/terraform_key.json",
            "sudo chmod 755 ~/terraform_harbor/terraform_key.json",
        ]
    }
}

# provisions the runner vm with necessary scripts and runs them to set up Harbor immediately
resource "null_resource" "install-harbor" {
    count = "${var.layer-2}"
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
        source = "${var.gcp-service-key}"
        destination = "${var.gcp-key-location}"
    }
    provisioner "remote-exec" {
        inline = [
            # uses the file from the other provisioner to install docker and download harbor
            "sudo chmod 755 /tmp/run-command.sh",
            "mkdir ~/terraform_harbor",
            "mv ~/terraform_key.json ~/terraform_harbor/terraform_key.json",
            "sudo chmod 755 ~/terraform_harbor/terraform_key.json",
            "sudo /tmp/run-command.sh",
        ]
    }
}