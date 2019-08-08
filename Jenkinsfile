pipeline {
  agent {
    node {
      label 'slave'
    }

  }
  stages {
    stage('build') {
      steps {
        sh 'dotnet build'
      }
    }
    stage('publish') {
      steps {
        sh '''sudo mkdir -p /var/www/aspnetcoreapp

sudo cp ${PWD}/aspnetcoreapp.service /etc/systemd/system/aspnetcoreapp.service
#sudo nano /etc/systemd/system/aspnetcoreapp.service
sudo dotnet publish -c Release -o /var/www/aspnetcoreapp
sudo systemctl enable aspnetcoreapp.service
'''
      }
    }
    stage('restart service') {
      steps {
        sh '''sudo service aspnetcoreapp start
'''
      }
    }
  }
}