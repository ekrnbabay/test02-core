#!/bin/bash
#AMI ID Ubuntu18_04JenkinsAspNetDocker
sudo apt update

sudo apt install openjdk-8-jdk -y

sudo apt-get update

sudo apt install npm -y


#docker install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker

#ubuntu .Net Core
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2 -y

# http://18.188.83.180:5000

curl -Is http://www.ya.ru | head -1
curl -Is https://localhost:5000 | head -1
curl -Is https://localhost:5001 | head -1

curl -Is http://www.localhost.ru | head -1
curl -Is 127.0.0.1:5000 | head -1

 zip -r /home/ubuntu/prj/*
 
#sudo apt-get install nginx -y
#sudo ufw allow OpenSSH
#sudo ufw enable
# systemctl status nginx # chek status

# First, add the repository key to the system:
#wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
#sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
#sudo apt update
#sudo apt install jenkins -y
#sudo systemctl start jenkins

# 290c4644a46a43dc9e6b2a3bae0b34d0
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword

#proxy_pass          http://localhost:3000;
#proxy_redirect      http://localhost:3000 https://ec2-18-188-89-119.us-east-2.compute.amazonaws.com/prg;