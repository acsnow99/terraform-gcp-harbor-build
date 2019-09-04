terraform apply -var-file=states/mc-server-2.tfvars
gcloud compute instances add-tags mc-server-2 --tags minecraft
gcloud compute firewall-rules create mc-server-firewall --allow udp:19132 \
--priority 500 --network terraform-gcp-harbor --target-tags minecraft