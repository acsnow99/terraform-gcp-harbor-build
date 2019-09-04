sudo apt-get update -y
sudo apt-get install -y chrony dnsmasq dnsutils jq
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
# install docker compose
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.24.0/run.sh -o /usr/local/bin/docker-compose
# executable permissions for compose
sudo chmod +x /usr/local/bin/docker-compose

# get terraform
cd
sudo apt-get install unzip
wget https://releases.hashicorp.com/terraform/0.12.4/terraform_0.12.4_linux_amd64.zip
unzip terraform_0.12.4_linux_amd64.zip
sudo mv terraform /usr/local/bin/

# start running commands based on the terraform scripts on github
cd ~/terraform_harbor
git clone https://github.com/IGNW/terraform-gcp-harbor-helm-linux.git
cd terraform-gcp-harbor-helm-linux
terraform init

# get gcloud sdk
curl -o google-cloud-sdk-257.0.0-linux-x86_64.tar.gz https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-257.0.0-linux-x86_64.tar.gz
tar zxvf google-cloud-sdk-257.0.0-linux-x86_64.tar.gz google-cloud-sdk
./google-cloud-sdk/install.sh
#gcloud init

# get kubectl
curl -o kubectl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

#sudo bash auto-cluster.sh