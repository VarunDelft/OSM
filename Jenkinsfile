pipeline {
  agent any
  stages {
    stage('Speak') {
      when {
        expression {
          params.REQUESTED_ACTION == 'greeting'
        }

      }
      steps {
        echo 'Hello, bitwiseman!'
      }
    }
  }
  parameters {
    choice(choices: '''greeting
silence''', description: '', name: 'REQUESTED_ACTION')
  }
}