// add definitions for region, project, 
// and network to match where in GCP you want this
prefix = "mc-server-java"

network = "minecraft"
subnet = "minecraft-1"

commandfile = "./resources/mc-install-java-docker.sh"
credentials-file = "~/terraform/terraform_keys/terraform-gcp-harbor-34467c272387.json"
layer-2 = "1"
image = "ubuntu-1804-bionic-v20190722a"
protocol = "tcp"
gcp-service-key = "~/terraform/gcp/harbor/terraform-gcp-harbor-build/resources/server.properties"
gcp-key-location = "/tmp/server.properties"
