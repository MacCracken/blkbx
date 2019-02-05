pipeline {
  agent {
    docker {
      image 'ruby:latest'
    }
  }

  stages {
    stage('Run Static Code Analysis') {
        steps {
          sh 'gem install bundle'
          sh 'bundle install'
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
