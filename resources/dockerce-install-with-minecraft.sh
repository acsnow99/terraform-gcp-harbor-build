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

apt-get install -y wget
apt-get install -y unzip
apt-get install -y libcurl4
mkdir ~/minecraft
wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.12.0.28.zip
unzip bedrock-server-1.12.0.28.zip -d ~/minecraft

mkdir ~/minecraft/worlds
mkdir ~/minecraft/worlds/DOINGUS
mkdir minecraft/worlds/DOINGUS/db
#~/terraform-key.json is actually a directory full of the data for the world
cp -r /tmp/db/* ~/minecraft/worlds/DOINGUS/db

echo "server-name=Alex's GCP Server
gamemode=survival
difficulty=normal
allow-cheats=false
max-players=10
online-mode=true
white-list=false
server-port=19132
server-portv6=19133
view-distance=32
tick-distance=4
player-idle-timeout=30
max-threads=8
level-name=Googland
level-seed=
default-player-permission-level=operator
texturepack-required=false" > ~/minecraft/server.properties

cd ~/minecraft
LD_LIBRARY_PATH=. ./bedrock_server