#!/bin/bash
echo "test dev" >> /home/ubuntu/dev.cfg
echo "${ENV} dev" >> /home/ubuntu/dev.cfg

mkdir -p /home/ubuntu/jenkins
sudo chown -R  ubuntu /home/ubuntu/jenkins
sudo apt-get update

#java 8
#sudo apt update
#sudo apt install openjdk-8-jdk -y
#sudo apt-get update
#sudo apt install npm -y

#build tool


exit 0