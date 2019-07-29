variable "region" {
    type = "string"
    default = "us-west1"
}
variable "project" {
    type = "string"
    default = "terraform-gcp-harbor"
}
variable "network" {
    type = "string"
    default = "terraform-gcp-harbor"
}

variable "prefix" {
    type = "string"
    default = "google-cloud-compute"
}

variable "image" {
    type = "string"
    default = "ubuntu-1604-xenial-v20190617"
}
variable "machine" {
    description = "Type of GCP machine to make the nodes on"
    default = "n1-standard-4"
}

variable "commandfile" {
    type = "string"
}
variable "credentials-file" {
    type = "string"
}

variable "layer-1" {
    description = "Set to 1 for a runner vm that has a script that must be run through ssh to set up a Harbor instance"
    default = "0"
}
variable "layer-2" {
    description = "Set to 1 for an auto-setup Harbor instance with less direct control"
    default = "0"
}