sudo apt-get update -y
sudo apt-get install -y chrony dnsmasq dnsutils jq
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

apt-get install -y default-jdk

mkdir ~/minecraft
mkdir ~/minecraft/FeedTheBeast
mv /tmp/server.properties ~/minecraft/FeedTheBeast/server.properties

#start the server
docker run -d -p 25565:25565 -e EULA=TRUE -e VERSION=1.12.2 -e TYPE=FTB -e FTB_SERVER_MOD=https://www.feed-the-beast.com/projects/ftb-presents-direwolf20-1-12/files/2690320 -v ~/minecraft:/data --name mc itzg/minecraft-server
