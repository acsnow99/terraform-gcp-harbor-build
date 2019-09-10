// add definitions for region, project, 
// and network to match where in GCP you want this
prefix = "mc-server-java"

network = "minecraft"
subnet = "minecraft-1"

commandfile = "./resources/mc-install-java-docker.sh"
credentials-file = "/keys/terraform-gcp-harbor-2-fbb45d835ed3.json"
layer-2 = "1"
image = "ubuntu-1804-bionic-v20190722a"
gcp-service-key = "./resources/server.properties"
gcp-key-location = "/tmp/server.properties"

project = "terraform-gcp-harbor-2"