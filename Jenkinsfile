node('docker') {
 
    stage 'Checkout'
        checkout scm

    stage 'Clear Environment'
        sh "terraform init"
        sh "terraform destroy -var-file=states/mc-server-java-jenkins.tfvars || true"
        sh "yes Y | gcloud compute firewall-rules delete mc-java-firewall || true"
  
    stage 'Integration Test'
        sh "bash resources/auto-mc-server-full.sh -g 1 -w Jenkos -v 1.12.2 -t states/mc-server-java-jenkins.tfvars"
}