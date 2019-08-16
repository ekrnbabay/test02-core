#!/bin/bash

sudo mkdir -p /var/www/aspnetcoreapp

sudo cp ${PWD}/aspnetcoreapp.service /etc/systemd/system/aspnetcoreapp.service
#sudo nano /etc/systemd/system/aspnetcoreapp.service
sudo dotnet publish -c Release -o /var/www/aspnetcoreapp
sudo systemctl enable aspnetcoreapp.service
#sudo service --status-all | grep aspnetcoreapp
#ps -ef | grep aspnetcoreapp
#sudo service aspnetcoreapp status
sudo service aspnetcoreapp stop
sudo service aspnetcoreapp start