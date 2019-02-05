pipeline {
  agent {
    docker {
      image 'ruby:latest'
    }
  }

  stages {
    stage('Install Requirements') {
      steps {
        sh 'gem install bundle'
        sh 'bundle install'
      }
    }
    stage('Run Static Code Analysis') {
      steps {
        sh 'rake rubocop'
      }
    }
    stage('Setup') {
      steps {
        sh 'bin/setup'
      }
    }
    stage('Run Spec Tests') {
      steps {
        sh 'rake spec'
      }
    }
  }
}
