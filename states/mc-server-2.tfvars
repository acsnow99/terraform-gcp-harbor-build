// add definitions for region, project, 
// and network to match where in GCP you want this
prefix = "mc-server-2"
commandfile = "./resources/dockerce-install-with-minecraft.sh"
credentials-file = "~/terraform/terraform_keys/terraform-gcp-harbor-34467c272387.json"
layer-2 = "1"
image = "ubuntu-1804-bionic-v20190722a"
protocol = "udp"
gcp-service-key = "~/minecraft-docker-git/worlds/WvvpXPNgAAA=/db"
gcp-key-location = "/tmp"