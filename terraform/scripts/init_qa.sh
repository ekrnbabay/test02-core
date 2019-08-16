#!/bin/bash
echo "test qa" >> /home/ubuntu/qa.cfg
echo "${ENV} qa" >> /home/ubuntu/qa.cfg

mkdir -p /home/ubuntu/jenkins
sudo chown -R  ubuntu /home/ubuntu/jenkins
sudo apt-get update

sudo snap install docker          # version 18.06.1-ce, or
sudo apt  install docker-compose -y
sudo systemctl daemon-reload
sudo usermod -aG docker ubuntu
grep docker /etc/group

#java 8
#sudo apt update
#sudo apt install openjdk-8-jdk -y
#sudo apt-get update
#sudo apt install npm -y

#build tool


exit 0