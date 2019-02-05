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
        sh 'rake spec'
      }
    }
  }
}
