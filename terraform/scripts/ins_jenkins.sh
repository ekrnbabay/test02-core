#!/bin/bash
echo "test slave" >> /home/ubuntu/slave.cfg
echo "${ENV} slave" >> /home/ubuntu/slave.cfg
mkdir /home/ubuntu/jenkinsbackup

sudo apt update

sudo apt install openjdk-8-jdk -y

sudo apt-get update

sudo apt install npm -y

#sudo apt-get install nginx -y
#sudo ufw allow OpenSSH
#sudo ufw enable
# systemctl status nginx # chek status

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl start jenkins

#http://3.17.162.232:8080/
#copy path
#/home/ubuntu/jenkins
#sudo tar -zcvf /home/ubuntu/jenkins.tar.gz /var/lib/jenkins
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword

exit 0