pipeline {
  agent {
    docker {
      image 'ruby:latest'
    }
  }

  stages {
    stage('Setup') {
      steps {
        sh 'add-apt-repository ppa:mozillateam/firefox-next'
        sh 'apt update && apt upgrade && apt install firefox google-chrome'
        sh 'curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
        sh 'chmod +x /usr/local/bin/docker-compose'
        sh 'docker-compose --version'
        sh 'bin/setup'
      }
    }
    stage('Static Code Analysis') {
      steps {
        sh 'rake rubocop'
      }
    }
    stage('Spec Tests') {
      steps {
        sh 'docker-compose up &'
        sh 'sleep 60'
        sh 'rake spec'
      }
    }
  }
}
