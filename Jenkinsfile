pipeline {
  agent any
  stages {
    stage('Build') {
      when {
        expression {
          params.REQUESTED_ACTION == 'greeting'
          sh "sshpass -p admin123 scp -P 8722 FirewallConfig osmadmin@192.168.60.215:LocalConfigCache/FirewallConfig" 
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
