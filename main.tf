provider "google" {
    credentials = "${file(var.credentials-file)}"
    project = "terraform-gcp-harbor"
    region = "${var.region}"
    zone = "${var.region}-a"
}

resource "google_compute_firewall" "default" {
    name = "${var.prefix}-firewall"
    network = "terraform-gcp-harbor"
    
    allow {
        protocol = "tcp"
    }
}

module "harbor-runner-instance" {
    source = "./modules/basic_instance"

    prefix = "${var.prefix}"
    image = "${var.image}"
    commandfile = "${var.commandfile}"
    machine = "${var.machine}"
}