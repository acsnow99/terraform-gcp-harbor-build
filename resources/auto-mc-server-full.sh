gamemode="0"
worldname="GCP"
version="1.14.4"
modpath=""
worldtype="DEFAULT"
modpack=""
tfvars="states/mc-server-java.tfvars"
bedrock_tfvars="states/mc-server-bedrock.tfvars"
run="n"

while getopts ":hg:w:v:m:f:be:rt:y" opt; do
  case ${opt} in
   h )
     echo "
BEFORE RUNNING, EDIT states/mc-server-java.tfvars SO THAT THE project AND credentials-file VARIABLES MATCH YOURS

Usage:
-g Gamemode of the server(0 or 1 for Java, survival or creative for Bedrock)
-w Worldname of the server
-v Version of Minecraft to use
-r Makes a Bedrock server instead of Java
-e Make the server with existing world files. Include the path to the directory of the world(should have the same name as the world)

Java-only flags:
-m Activates Forge; path to the mod file(.jar) required
-b Creates a Biomes 'O' Plenty world if -f or -m is also called and the modpath after -m points to the Biomes 'O' Plenty mod file
-f Activates FTB; URL or path of modpack required

-t Alternate .tfvars file to run Terraform with, to change the setup of the server machine. Copy states/mc-server-java.tfvars or states/mc-server-bedrock.tfvars to get started.

Note: Make sure the modpacks and mods match the version of Minecraft under the -v flag
Other Note: Using both -m and -f will only activate -m
" 1>&2
     exit 1
     ;;
   g )
     gamemode=$OPTARG 
     ;;
   w )
     worldname=$OPTARG 
     ;;
   v )
     version=$OPTARG
     ;;
   m )
     modded=true
     modpath=$OPTARG
     ;;
   b )
     worldtype=BIOMESOP
     ;;
   f )
     ftb=true
     modpack=$OPTARG
     ;;
   e )
     exists=true
     worldpath=$OPTARG
     ;;
   r )
     bedrock=true
     ;;
   t )
     tfvars=$OPTARG
     bedrock_tfvars=$OPTARG
     ;;
   y )
     run="y"
     ;;
   \? )
     echo "Invalid Option: -$OPTARG

BEFORE RUNNING, EDIT states/mc-server-java.tfvars SO THAT THE project AND credentials-file VARIABLES MATCH YOURS

Usage:
-g Gamemode of the server(0 or 1 for Java, survival or creative for Bedrock)
-w Worldname of the server
-v Version of Minecraft to use
-r Makes a Bedrock server instead of Java
-e Make the server with existing world files. Include the path to the directory of the world(should have the same name as the world)

Java-only flags:
-m Activates Forge; path to the mod file(.jar) required
-b Creates a Biomes 'O' Plenty world if -f or -m is also called and the modpath after -m points to the Biomes 'O' Plenty mod file
-f Activates FTB; URL or path of modpack required

-t Alternate .tfvars file to run Terraform with, to change the setup of the server machine. Copy states/mc-server-java.tfvars or states/mc-server-bedrock.tfvars to get started.

Note: Make sure the modpacks and mods match the version of Minecraft under the -v flag
Other Note: Using both -m and -f will only activate -m
" 1>&2
     exit 1
     ;;
   : )
     echo "Invalid option: $OPTARG requires an argument" 1>&2
     exit 1
     ;;
  esac
done
shift $((OPTIND -1))


#replace spaces with dashes
worldname="$(echo $worldname | tr ' ' '-')"


echo -e "spawn-protection=16
max-tick-time=60000
query.port=25565
generator-settings=
force-gamemode=false
allow-nether=true
gamemode="${gamemode}"
enable-query=false
player-idle-timeout=0
difficulty=1
spawn-monsters=true
op-permission-level=4
pvp=true
snooper-enabled=true
level-type="${worldtype}"
hardcore=false
enable-command-block=true
network-compression-threshold=256
max-players=20
resource-pack-sha1=
max-world-size=29999984
rcon.port=25575
server-port=25565
texture-pack=
server-ip=
spawn-npcs=true
allow-flight=false
level-name="${worldname}"
view-distance=10
displayname=Fill this in if you have set the server to public\!
resource-pack=
discoverability=unlisted
spawn-animals=true
white-list=false
rcon.password=minecraft
generate-structures=true
online-mode=true
max-build-height=256
level-seed=
use-native-transport=true
prevent-proxy-connections=false
motd=A Minecraft Server powered by K8S
enable-rcon=true" > ./resources/server.properties


if [ $bedrock ]
then
  if [ $run = n ]
  then
    echo "This command will create a Bedrock version "${version}" world titled '"${worldname}"' Continue(y or n)?"
    read run
  fi
  if [ $run = y ]
  then
    echo "Then here we go!"

    echo 'sudo apt-get update -y
sudo apt-get install -y chrony dnsmasq dnsutils jq
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

mkdir ~/minecraft
mkdir ~/minecraft/worlds
mkdir ~/minecraft/worlds/'${worldname}'

#start the server
docker run -d -p 19132:19132/udp -e EULA=TRUE -e VERSION='${version}' -e LEVEL_NAME='${worldname}' -e GAMEMODE='${gamemode}' -v ~/minecraft:/data --name mc itzg/minecraft-bedrock-server' > ./resources/mc-install-bedrock-docker.sh

    terraform init
    yes yes | terraform apply -var-file=$bedrock_tfvars
    machine=$(terraform output | sed '1d' | awk '{gsub("machine-name = ", "");print}')
    gcloud compute instances add-tags $machine --tags mc-bedrock
    gcloud compute firewall-rules create mc-bedrock-firewall --allow udp \
    --priority 1000 --network minecraft --target-tags mc-bedrock 2> errors.txt


    if [ $exists ]
    then 
      ip=$(terraform output | sed '2d' | tr -d "instance-ip = -")
      user=$(whoami)

      # copy world files over
      gcloud compute ssh --zone us-west1-a $machine --command 'sudo docker stop mc'
      gcloud compute ssh --zone us-west1-a $machine --command 'sudo docker start mc'
      #gcloud compute ssh --zone us-west1-a mc-server-bedrock --command 'sudo rm -r /home/'${user}'/minecraft/worlds/'${worldname}''
      scp -r $worldpath/db $user@$ip:/home/$user/
      ssh $user@$ip sudo rm -r /home/$user/minecraft/worlds/$worldname/db 
      ssh $user@$ip sudo cp -r /home/$user/db /home/$user/minecraft/worlds/${worldname}/
      gcloud compute ssh --zone us-west1-a $machine --command 'sudo docker stop mc'
      gcloud compute ssh --zone us-west1-a $machine --command 'sudo docker start mc'
      #gcloud compute ssh --zone us-west1-a mc-server-bedrock --command 'sudo chmod -R 777 /home/alexsnow/minecraft/worlds/'${worldname}''
    fi

  else
    echo "Server creation cancelled"
  fi


else
  if [ $modded ]
  then
    if [ $run = n ]
    then
      echo "This command will create a Forge-modded version "${version}" world titled '"${worldname}"' with the mod at
"${modpath}" 
installed. Continue(y or n)?"
      read run
    fi
    if [ $run = y ]
    then
      echo "Then here we go!"

      echo 'sudo apt-get update -y
sudo apt-get install -y chrony dnsmasq dnsutils jq
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

apt-get install -y default-jdk

mkdir ~/minecraft
mv /tmp/server.properties ~/minecraft/server.properties

#start the server
docker run -d -p 25565:25565 -e EULA=TRUE -e VERSION='${version}' -e TYPE=FORGE -v ~/minecraft:/data --name mc itzg/minecraft-server' > ./resources/mc-install-java-docker.sh

    else
      echo "Server creation cancelled"
    fi
  else 
    if [ $ftb ]
    then 
      if [ $run = n ]
      then
        echo "This command will create a FeedTheBeast version "${version}" world titled '"${worldname}"' with the modpack at
'${modpack}'
installed. Continue(y or n)?"
        read run
      fi
      if [ $run = y ]
      then
        echo "Then here we go!"

        echo 'sudo apt-get update -y
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
docker run -d -p 25565:25565 -e EULA=TRUE -e VERSION='${version}' -e TYPE=FTB -e FTB_SERVER_MOD='${modpack}' -v ~/minecraft:/data --name mc itzg/minecraft-server' > ./resources/mc-install-java-docker.sh

      else
        echo "Server creation cancelled"
      fi
    else 
      if [ $run = n ]
      then
        echo "This command will create a vanilla version "${version}" world titled '"${worldname}".' Continue(y or n)?"
        read run
      fi
      if [ $run = y ]
      then
        echo "Then here we go!"

        echo 'sudo apt-get update -y
sudo apt-get install -y chrony dnsmasq dnsutils jq
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo docker run hello-world

apt-get install -y default-jdk

mkdir ~/minecraft
mv /tmp/server.properties ~/minecraft/server.properties

#start the server
docker run -d -p 25565:25565 -e EULA=TRUE -e VERSION='${version}' -v ~/minecraft:/data --name mc itzg/minecraft-server' > ./resources/mc-install-java-docker.sh

      else
        echo "Server creation cancelled"
      fi
    fi
  fi

  if [ $run = y ]
  then

      # 2> errors.txt means that errors for resources already existing will go into a file instead of confusing the user
      gcloud compute networks create minecraft \
      --subnet-mode=custom \
      --bgp-routing-mode=regional 2> errors.txt
      gcloud compute networks subnets create minecraft-1 \
      --network=minecraft \
      --range=10.0.0.0/9 \
      --region=us-west1 2> errors.txt

      terraform init
      yes yes | terraform apply -var-file=$tfvars
      machine=$(terraform output | sed '1d' | awk '{gsub("machine-name = ", "");print}')
      gcloud compute instances add-tags $machine --tags mc-java
      gcloud compute firewall-rules create mc-java-firewall --allow tcp \
      --priority 1000 --network minecraft --target-tags mc-java 2> errors.txt

      ip=$(terraform output | sed '2d' | tr -d "instance-ip = -")
      user=$(whoami)


      if [ $exists ]
      then 
        # copy world files over
        if [ $ftb ]
        then
          gcloud compute ssh --zone us-west1-a $machine --command 'sudo rm -r ~/minecraft/FeedTheBeast/'${worldname}''
          scp -r $worldpath $user@$ip:/home/$user/
          ssh $user@$ip sudo mv /home/$user/$worldname /home/$user/minecraft/FeedTheBeast
          gcloud compute ssh --zone us-west1-a $machine --command 'sudo chmod -R 777 /home/'${user}'/minecraft/FeedTheBeast/'${worldname}''
        else
          gcloud compute ssh --zone us-west1-a $machine --command 'sudo rm -r ~/minecraft/'${worldname}''
          scp -r $worldpath $user@$ip:/home/$user/
          ssh $user@$ip sudo mv /home/$user/$worldname /home/$user/minecraft
          gcloud compute ssh --zone us-west1-a $machine --command 'sudo chmod -R 777 /home/'${user}'/minecraft/'${worldname}''
        fi

        # restart server
        gcloud compute ssh --zone us-west1-a $machine --command 'sudo docker stop mc'
        gcloud compute ssh --zone us-west1-a $machine --command 'sudo docker start mc'
      fi 
  fi
fi