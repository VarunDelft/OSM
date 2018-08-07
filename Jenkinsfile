pipeline {
  agent any
  stages {
    stage('Build') {
      when {
        expression {
          params.REQUESTED_ACTION == 'greeting'
          echo 'Hello There!'
        }

      }
      steps {
        echo 'Hello There'
      }
    }
  }
  parameters {
    choice(choices: '''greeting
silence''', description: '', name: 'REQUESTED_ACTION')
  }
}
