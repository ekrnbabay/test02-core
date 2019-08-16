#!/bin/bash
echo "test0" >> /home/ubuntu/init_empty.file  
mkdir -p /home/ubuntu/jenkins
sudo chown -R  ubuntu /home/ubuntu/jenkins
exit 0