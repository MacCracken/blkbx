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
        withSonarQubeEnv('v3.3.0') {
           sh 'mvn clean package sonar:sonar' +
             '-Dsonar.projectKey=blkbx:all:master ' +
             '-Dsonar.sources=. ' +
             '-Dsonar.ruby.rubocop.reportPaths=rubocop-report.json'
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

    stage("Quality Gate") {
      steps {
          timeout(time: 1, unit: 'HOURS') {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }
  }
}
