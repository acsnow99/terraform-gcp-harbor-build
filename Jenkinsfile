node('docker') {
 
    stage 'Checkout'
        checkout scm

    stage 'Clear Environment'
        sh "terraform init"
        sh "yes yes | terraform destroy -var-file=states/mc-server-java-jenkins.tfvars || true"
        sh "yes Y | gcloud compute firewall-rules delete mc-java-firewall || true"
        sh "yes Y | gcloud compute firewall-rules delete mc-server-java-jenkins-firewall || true"
        sh "yes Y | gcloud compute instances delete mc-server-java-jenkins || true"
  
    stage 'Integration Test'
        sh "bash resources/auto-mc-server-full.sh -y -g 1 -w Jenkos -v 1.12.2 -t states/mc-server-java-jenkins.tfvars"
}