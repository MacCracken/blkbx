pipeline {
  agent {
    docker {
      image 'ruby:latest'
    }
  }

  stages {
    stage('Setup') {
      steps {
        sh 'curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose'
        sh 'chmod +x /usr/local/bin/docker-compose'
        sh 'docker-compose --version'
        sh 'bin/setup'
      }
    }
    stage('Static Code Analysis') {
      steps {
        sh 'rake rubocop --format json --out rubocop-report.json'
      }
      node {
        withSonarQubeEnv('My SonarQube Server') {
           sh 'mvn clean package sonar:sonar'
        }
      }
    }
    stage("Quality Gate"){
      timeout(time: 1, unit: 'HOURS') {
        def qg = waitForQualityGate()
        if (qg.status != 'OK') {
            error "Pipeline aborted due to quality gate failure: ${qg.status}"
        }
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
