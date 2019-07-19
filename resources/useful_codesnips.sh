# create ssh keys to set up a gcp instance through terraform
cd ~/.ssh
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# copy auto-created cert from dockerce-harbor-master-install.sh or dockerce-install.sh to a local machine
scp -v alexsnow@ip_address:~/ca.crt .

# then move the file into the corresponding .docker/certs.d directory:
# on Mac
mkdir ~/.docker/certs.d
mkdir ~/.docker/certs.d/ip_address
sudo mv ca.crt ~/.docker/certs.d/ip_address/ca.crt
# restart Docker Daemon

# on Linux:
mkdir /etc/docker/certs.d
mkdir /etc/docker/certs.d/ip_address
sudo mv ca.crt /etc/docker/certs.d/ip_address/ca.crt

# on some machines, the user is not in the docker group by default, so:
sudo usermod -aG docker $USER
# then log out and in again



# order of events for new harbor runner:
sudo docker login --username admin --password Harbor12345 ip_address
sudo docker tag hello-world:latest ip_address/library/hello-world:latest
sudo docker push ip_address/library/hello-world:latest
