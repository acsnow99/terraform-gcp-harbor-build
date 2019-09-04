terraform apply -var-file=states/mc-server.tfvars
gcloud compute instances add-tags mc-server --tags minecraft
gcloud compute firewall-rules create mc-server-firewall --allow udp:19132 \
--priority 500 --network minecraft --target-tags minecraft