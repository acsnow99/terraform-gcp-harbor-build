apt-get update
apt-get install -y wget
apt-get install -y unzip
apt-get install -y libcurl4
apt-get install -y default-jdk
mkdir ~/minecraft
cd ~/minecraft

#go to https://mcversions.net/ for older version server files
wget https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar

#initialize the server directory
java -Xmx1024M -Xms1024M -jar server.jar nogui

echo "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).
#Tue Sep 03 21:02:45 UTC 2019
eula=true" > eula.txt
mv /tmp/server.properties ~/minecraft/server.properties

#actually start the server
java -Xmx1024M -Xms1024M -jar server.jar nogui &