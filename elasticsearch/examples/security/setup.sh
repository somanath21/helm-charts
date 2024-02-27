#!/bin/bash
wget http://security.ubuntu.com/ubuntu/pool/main/a/apt/apt_1.4_amd64.deb
sudo dpkg -i apt_1.4_amd64.deb
sudo apt-get update
apt install sudo
sudo apt-get --assume-yes install apt-transport-https ca-certificates curl gnupg lsb-release
apt-get install --assume-yes apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list
apt-get install --assume-yes kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
sudo apt-get install --assume-yes kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
apt-get install sysvinit-utils
sudo apt-get --assume-yes install docker-ce docker-ce-cli containerd.io
whoami
apt install sysvinit-utils
sudo service docker start
sleep 2s
sudo docker run hello-world
sudo service docker status
echo ----------------- docker status ---------------------
