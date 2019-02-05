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
    stage('Run Static Code Analysis') {
      steps {
        sh 'rake rubocop'
      }
    }
    stage('Run Spec Tests') {
      steps {
        sh 'rake spec'
      }
    }
  }
}
