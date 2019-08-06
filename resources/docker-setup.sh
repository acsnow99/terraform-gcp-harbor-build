# script to automatically set up a Harbor instance you can push images to

yes yes | terraform apply -var-file=states/harbor-runner2.tfvars

# get the ip address from the terraform output into the rest of the script
ip=$(terraform output | tr -d "instance-ip = -")

#cd certs
#mkdir $ip-certs

#openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 3650 -out ca.crt -subj "/C=US/ST=Oregon/L=Portland/0=IGNW/OU=Devops/CN=."
#openssl req -newkey rsa:4096 -nodes -sha256 -keyout harbor.gcp.key -out harbor.gcp.csr -subj "/C=US/ST=Oregon/L=Portland/0=IGNW/OU=Devops/CN=."
#touch extfile.cnf
#echo subjectAltName = IP:$ip > extfile.cnf
#openssl x509 -req -days 3650 -in harbor.gcp.csr -CA ca.crt -CAkey ca.key -CAcreateserial -extfile extfile.cnf -out harbor.gcp.crt
#sudo cp *.crt *.key ./$ip-certs
#sudo rm *.crt *.srl *.cnf *.csr *.key

# get the cert from the instance(on Mac)
scp -i /home/alexsnow/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v alexsnow@$ip:~/terraform_harbor/terraform-gcp-harbor-instance/ip.txt .
ip2=$(cat ip.txt)
scp -i /home/alexsnow/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -v alexsnow@$ip:/etc/docker/certs.d/$ip2/ca.crt .

sudo mkdir ~/.docker/certs.d/$ip2
sudo mv ca.crt ~/.docker/certs.d/$ip2/ca.crt

killall Docker && open /Applications/Docker.app

sleep 60

# login to docker and push a test image
sudo docker login --username admin --password Harbor12345 $ip2
sudo docker tag busybox $ip2/library/busybox
sudo docker push $ip2/library/busybox
