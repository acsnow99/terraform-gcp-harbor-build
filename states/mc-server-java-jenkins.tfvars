// add definitions for region, project, 
// and network to match where in GCP you want this
prefix = "mc-server-java-jenkins"

network = "minecraft"
subnet = "minecraft-1"

commandfile = "./resources/mc-install-java-docker.sh"
credentials-file = "/var/jenkins_home/terraform_keys/terraform-gcp-harbor-2-45311dea3003.json"
layer-2 = "1"
image = "ubuntu-1804-bionic-v20190722a"
protocol = "tcp"
gcp-service-key = "/var/jenkins_home/terraform-gcp-harbor-build/resources/server.properties"
gcp-key-location = "/tmp/server.properties"

project = "terraform-gcp-harbor-2"