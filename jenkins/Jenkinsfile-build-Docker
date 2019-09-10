node('docker') {
 
    stage 'Checkout'
        checkout scm

    stage 'Build & UnitTest'
        sh "docker build -t mc-bedrock-personal ./mc-docker-rebuild-jenkins"
        sh "gcloud compute firewall-rules create mc-bedrock-firewall --allow udp \
--priority 1000 --network default --target-tags mc-bedrock || true"
  
    stage 'Integration Test'
        sh "docker kill mc-built || true"
        sh "docker rm mc-built || true"
        sh "docker run -d -p 19132:19132/udp -e EULA=TRUE -e VERSION=1.12 -e LEVEL_NAME=Eoea -e GAMEMODE=survival -v ~/minecraft:/data --name mc-built itzg/minecraft-bedrock-server"
}