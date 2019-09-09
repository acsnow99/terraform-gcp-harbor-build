node('docker') {
 
    stage 'Checkout'
        checkout scm
    //stage 'Build & UnitTest'
    //    sh "docker build -t accountownerapp:B${BUILD_NUMBER} -f Dockerfile ."
    //    sh "docker build -t accountownerapp:test-B${BUILD_NUMBER} -f Dockerfile.Integration ."
  
    stage 'Integration Test'
        sh "mkdir ~/minecraft"
        sh "docker run -d -p 19132:19132/udp -e EULA=TRUE -e VERSION=1.12 -e LEVEL_NAME=Eoea -e GAMEMODE=creative -v ~/minecraft:/data --name mc itzg/minecraft-bedrock-server"
}