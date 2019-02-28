pipeline {
  agent {
    docker {
      image 'ruby:latest'
    }
  }

  node {
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
           sh 'mvn clean package sonar:sonar'
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
  
  stage("Quality Gate"){
    timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
      def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
      if (qg.status != 'OK') {
        error "Pipeline aborted due to quality gate failure: ${qg.status}"
      }
    }
  }
}
