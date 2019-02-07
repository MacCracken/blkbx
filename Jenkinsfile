pipeline {
  agent {
    docker {
      image 'ruby:latest'
    }
  }

  stages {
    stage('Setup') {
      steps {
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
        sh 'docker-compose up & >/dev/null'
        sh 'sleep 60'
        sh 'rake spec'
      }
    }
  }
}
