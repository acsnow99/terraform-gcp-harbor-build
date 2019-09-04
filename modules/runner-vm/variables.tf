variable "prefix" {
    description = "Name for the entire system(e.g. harbor-ubuntu)"
}

variable "network" {
    default = "terraform-gcp-harbor"
}
variable "subnet" {
    default = "harbor-repo-0"
}

variable "image" {
    description = "Which operating system to pull from GCP"
}

variable "commandfile" {
    description = "File with instructions on how to install Harbor and other tools, plus any additional instructions after install"
}

variable "machine" {
    description = "Type of GCP machine to create the node on"
    default = "n1-standard-4"
}

variable "layer-1" {
    description = "Set to 1 for a runner vm that has a script that must be run through ssh to set up a Harbor instance"
    default = "0"
}
variable "layer-2" {
    description = "Set to 1 for an auto-setup Harbor instance with less direct control"
    default = "0"
}

variable "gcp-service-key" {

}
variable "gcp-key-location" {

}