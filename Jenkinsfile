node('docker') {
 
    stage 'Checkout'
        checkout scm
    //stage 'Build & UnitTest'
    //    sh "docker build -t accountownerapp:B${BUILD_NUMBER} -f Dockerfile ."
    //    sh "docker build -t accountownerapp:test-B${BUILD_NUMBER} -f Dockerfile.Integration ."
  
    stage 'Integration Test'
        sh "docker build -t mc-bedrock-personal ./mc-docker-rebuild-jenkins"
        sh "docker run -d -p 19132:19132/udp -e EULA=TRUE -e VERSION=1.12 -e LEVEL_NAME=Eoea -e GAMEMODE=survival -v ~/minecraft:/data --name mc-built mc-bedrock-personal"
}