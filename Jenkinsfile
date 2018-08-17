pipeline {
  agent any
  stages {
    stage('Build') {
      when {
        expression {
          params.REQUESTED_ACTION == 'greeting'
          sh "sshpass -p admin123 scp -P 8722 -o 'StrictHostKeyChecking=no' FirewallConfig osmadmin@192.168.60.215:LocalConfigCache/FirewallConfig" 
          sh "export CLIENT_PWD=`jq .CLIENT_PWD TestData.json`"
          sh "export CLIENT_UID=`jq .CLIENT_UID TestData.json`"
          sh "export CLIENT_IP=`jq .CLIENT_IP TestData.json`"
          sh "sshpass -p ${CLIENT_PWD//\"} scp  -o 'StrictHostKeyChecking=no' TestServerConnectivity.sh ${CLIENT_UID//\"}@${CLIENT_IP//\"}:TestScripts/TestServerConnectivity.sh"
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
