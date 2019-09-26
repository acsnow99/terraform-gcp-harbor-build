// add definitions for region, project, 
// and network to match where in GCP you want this
prefix = "harbor-runner"
commandfile = "./resources/dockerce-install.sh"
credentials-file = "~/terraform/terraform_keys/terraform-gcp-harbor-2-45311dea3003.json"
layer-2 = "1"

gcp-service-key = "~/Downloads/terraform-gcp-harbor-2-72245571699e.json"

project = "terraform-gcp-harbor-2"

network = "default"
subnet = "default"