1) #Install .Net Core for all unix
https://dotnet.microsoft.com/learn/dotnet/hello-world-tutorial/install


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



 ## Running the sample using Docker
 1)
 Need to add 3 files:
 .dockerignore
 docker-compose.yml
 /aspnetcoreapp/Dockerfile
 
 2)
You can run the Web sample by running these commands from the root folder (where the .sln file is located):

```
    docker-compose build
    docker-compose up
```

You should be able to make requests to localhost:5106 once these commands complete.

You can also run the Web application by using the instructions located in its `Dockerfile` file in the root of the project. Again, run these commands from the root of the solution (where the .sln file is located).
