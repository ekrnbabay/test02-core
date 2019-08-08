pipeline {
  agent {
    node {
      label 'lblmain'
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
        sh 'sudo dotnet publish -c Release -o /var/www/aspnetcoreapp'
      }
    }
    stage('restart service') {
      steps {
        sh 'sudo service aspnetcoreapp start'
      }
    }
  }
  environment {
    lblmain = 'lblmain'
  }
}