properties([pipelineTriggers([githubPush()])])
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        dir ('services/') {
          sh './run.sh'
        }
      }
    }  
  }
}
