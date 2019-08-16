#!/bin/bash
echo "test0" > test.file  
cd /home/ec2-user
echo "test1" > test1.file  
mkdir terraformlab
cd terraformlab
sudo wget https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip
sudo unzip terraform_0.12.5_linux_amd64.zip
echo $"export PATH=\$PATH:$(pwd)" >> ~/.bash_profile
source ~/.bash_profile
export TF_LOG="TRACE"
export TF_LOG_PATH="/home/ec2-user/terraformlog.txt"