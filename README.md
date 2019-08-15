1) #Install .Net Core for all unix
https://dotnet.microsoft.com/learn/dotnet/hello-world-tutorial/install
#config
/etc/nginx/sites-available/default
sudo service nginx stop
service --status-all
#check
curl -Is 127.0.0.1:5000 | head -1

2) Launch .NET Core web application on a Ubuntu 16.04 Server
https://www.youtube.com/watch?v=3Lq7jzACP0A


3) Jenkins user right for sudo command
https://gist.github.com/hayderimran7/9246dd195f785cf4783d

1. On ubuntu based systems, run " $ sudo visudo "
2. this will open /etc/sudoers file.
3. If your jenkins user is already in that file, then modify to look like this:

jenkins ALL=(ALL) NOPASSWD: ALL
4. save the file by doing Ctrl+O  (dont save in tmp file. save in /etc/sudoers, confirm overwrite)
5. Exit by doing Ctrl+X
6. Relaunch your jenkins job 
7. you shouldnt see that error message again :)

About setup.sh and aspnetcoreapp.service
https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/linux-nginx?view=aspnetcore-2.2


#if aspnetcoreapp service instaled? 
sudo systemctl daemon-reload
sudo service aspnetcoreapp stop

#for Linux ubuntu
sudo snap install docker          # version 18.06.1-ce, or
sudo apt  install docker-compose -y

#slave setup docker ps
cd /home/ubuntu/jenkins/workspace/aspnetcore

#QA project folder
/home/ubuntu/aspnetcore_release

sudo usermod -aG docker $USER

 ## Running the sample using Docker
 1)
 Need to add 3 files in project:
 .dockerignore
 docker-compose.yml
 /aspnetcoreapp/Dockerfile
 
 2)
You can run the Web sample by running these commands from the root folder (where the .sln file is located):

#Linux:
sudo docker-compose build
sudo docker-compose up -d

#Windows:
docker-compose build
docker-compose up -d

```
You should be able to make requests to localhost:5106 once these commands complete.
```
You can also run the Web application by using the instructions located in its `Dockerfile` file in the root of the project. Again, run these commands from the root of the solution (where the .sln file is located).

#Check
curl -Is 127.0.0.1 | head -1
curl -Is 127.0.0.1:5000 | head -1



git checkout release
git pull
git merge origin/develop
git push

but for push need generate SSH-key
merge test 12

jenkins 3 jobs:
#
1) aspnetcore
https://github.com/ekrnbabay/test02-core.git

dotnet build

ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.25 "mkdir -p /home/ubuntu/aspnetcore"
ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.25 "sudo rm -r /home/ubuntu/aspnetcore"
scp -i /home/ubuntu/.ssh/aws_firsttest.pem -r /home/ubuntu/jenkins/workspace/aspnetcore ubuntu@172.31.1.25:/home/ubuntu/
ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.25 "cd /home/ubuntu/aspnetcore/;sudo chmod +x deployprj.sh"
ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.25 "cd /home/ubuntu/aspnetcore/;./deployprj.sh"

#
2) aspnetcore_merge
Projects to watch	aspnetcore


rm -rf test02-core

git clone git@github.com:ekrnbabay/test02-core.git -b develop

cd test02-core
git checkout release
git pull
git merge origin/develop
git push

#
3) aspnetcore_release
https://github.com/ekrnbabay/test02-core.git

echo 'deploy in QA docker'

ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.20 "mkdir -p /home/ubuntu/aspnetcore"
ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.20 "sudo rm -r /home/ubuntu/aspnetcore"
scp -i /home/ubuntu/.ssh/aws_firsttest.pem -r /home/ubuntu/jenkins/workspace/aspnetcore_release ubuntu@172.31.1.20:/home/ubuntu/
ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.20 "cd /home/ubuntu/aspnetcore_release/;sudo chmod +x deployondocer.sh"
ssh -i /home/ubuntu/.ssh/aws_firsttest.pem ubuntu@172.31.1.20 "cd /home/ubuntu/aspnetcore_release/;./deployondocer.sh"
