#!/bin/bash
echo "test slave" >> /home/ubuntu/slave.cfg
echo "${ENV} slave" >> /home/ubuntu/slave.cfg

mkdir -p /home/ubuntu/jenkins
sudo chown -R  ubuntu /home/ubuntu/jenkins


#java 8 for empty instance
#sudo apt update
#sudo apt install openjdk-8-jdk -y
#sudo apt-get update
#sudo apt install npm -y

#build tool


exit 0