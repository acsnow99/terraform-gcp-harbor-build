node('docker') {
 
    stage 'Checkout'
        checkout scm

    stage 'Clear Environment'
        sh "terraform init"
        sh "yes yes | terraform destroy -var-file=states/mc-server-java-jenkins.tfvars || true"
        sh "yes Y | gcloud compute firewall-rules delete mc-java-firewall || true"
        sh "yes Y | gcloud compute firewall-rules delete mc-server-java-jenkins-firewall || true"
        sh "yes Y | gcloud compute instances delete mc-server-java-jenkins --zone us-west1-a || true"
  
    stage 'Integration Test'
        sh "gcloud config set account jenkins-mc-builder@terraform-gcp-harbor-2.iam.gserviceaccount.com && gcloud auth activate-service-account --key-file=/keys/terraform-gcp-harbor-2-72245571699e.json"
        sh "gcloud config set compute/zone us-west1-a"
        sh "bash resources/auto-mc-server-full.sh -y -f -g 1 -w Toast -e /opt/jenkins-haproxy/jenkins/jenkins-home/worlds/Toast -v 1.12.2 -t states/mc-server-java-jenkins.tfvars"
}