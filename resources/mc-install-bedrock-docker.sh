sudo apt-get update -y
sudo apt-get install -y chrony dnsmasq dnsutils jq
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

mkdir ~/minecraft
mkdir ~/minecraft/worlds
mkdir ~/minecraft/worlds/DOINGUS

#start the server
docker run -d -p 19132:19132/udp -e EULA=TRUE -e VERSION=1.12 -e LEVEL_NAME=DOINGUS -e GAMEMODE=creative -v ~/minecraft:/data --name mc itzg/minecraft-bedrock-server
