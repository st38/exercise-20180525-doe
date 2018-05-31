pipeline {
  
  environment {
    user="st38"
    repository="exercise-20180525-doe"
  }
  
  agent any
  stages {
    stage('Get scripts from GitHub'){
      steps {
        sh 'git clone https://github.com/$user/$repository'
        sh 'cd $repository'
      }
    }
    
    stage('Build docker container') {
      steps { 
        sh 'bash ./01-created-docker-container.sh'
      }
    }

    stage('Push docker container to Docker Hub') {
      steps { 
        sh 'bash ./02-push-docker-container.sh'
      }
    }

    stage('Deploy docker container') {
      steps {
        sh 'bash ./03-deploy-docker-container.sh'
      }
    }
  }

  post {
    success{
      deleteDir ()
    }
    always{
      deleteDir()
    }
    failure{
        deleteDir()
    }
    aborted{
        deleteDir()
    }
  }
}