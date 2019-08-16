#install java if need 
sudo apt update
sudo apt install openjdk-8-jdk -y
sudo apt-get update
sudo apt install npm -y

#install  .Net Core on the ubuntu
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2 -y

#web nginx
sudo apt-get install nginx -y

#Publish project ubuntu from jenkins dir to /var/www/aspnetcoreapp
sudo mkdir -p /var/www/aspnetcoreapp

sudo cp ${PWD}/aspnetcoreapp.service /etc/systemd/system/aspnetcoreapp.service
#sudo nano /etc/systemd/system/aspnetcoreapp.service
sudo dotnet publish -c Release -o /var/www/aspnetcoreapp
sudo systemctl enable aspnetcoreapp.service
sudo service aspnetcoreapp start
# service --status-all
  
#setup proxy nginx from port 5000
...

setup jenkins by CLI

java -jar jenkins-cli.jar -s http://18.224.44.147:8080/ help

#setup docker
sudo docker info