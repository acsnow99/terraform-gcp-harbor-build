provider "google" {
    credentials = "${file(var.credentials-file)}"
    project = "${var.project}"
    region = "${var.region}"
    zone = "${var.region}-a"
}

resource "google_compute_firewall" "default" {
    name = "${var.prefix}-firewall"
    network = "${var.network}"
    
    allow {
        protocol = "tcp"
    }
}

module "harbor-runner-instance" {
    source = "./modules/runner-vm"

    prefix = "${var.prefix}"
    image = "${var.image}"
    commandfile = "${var.commandfile}"
    machine = "${var.machine}"
    layer-1 = "${var.layer-1}"
    layer-2 = "${var.layer-2}"
}
