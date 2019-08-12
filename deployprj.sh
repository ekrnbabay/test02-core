#!/bin/bash

sudo mkdir -p /var/www/aspnetcoreapp

sudo cp ${PWD}/aspnetcoreapp.service /etc/systemd/system/aspnetcoreapp.service
#sudo nano /etc/systemd/system/aspnetcoreapp.service
sudo dotnet publish -c Release -o /var/www/aspnetcoreapp
sudo systemctl enable aspnetcoreapp.service
sudo service aspnetcoreapp start