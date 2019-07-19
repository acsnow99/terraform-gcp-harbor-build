variable "region" {
    type = "string"
    default = "us-west1"
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