prefix = "basic-docker-from-jenkins"
commandfile = "./resources/just-dockerce-install.sh"
credentials-file = "/var/jenkins_home/terraform_keys/terraform-gcp-harbor-2-45311dea3003.json"
layer-2 = "1"

project = "terraform-gcp-harbor-2"
image = "centos-7-v20190729"

network = "default"
subnet = "default"

gcp-service-key = "/var/jenkins_home/terraform_keys/terraform-gcp-harbor-2-45311dea3003.json"
gcp-key-location = "~/terraform_key.json"