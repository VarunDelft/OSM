pipeline {
  agent any
  stages {
    stage('Build') {
      when {
        expression {
          params.REQUESTED_ACTION == 'greeting'
          
      }
      steps {
        sh "sshpass -p admin123 scp -P 8722 -o 'StrictHostKeyChecking=no' FirewallConfig osmadmin@192.168.60.215:LocalConfigCache/FirewallConfig" 
          def props = readJSON file: 'TestData.json'
          props.CLIENT_PWD = "\'" + props.CLIENT_PWD + "\'"
          sh "sshpass -p ${props.CLIENT_PWD} scp  -o 'StrictHostKeyChecking=no' TestServerConnectivity.sh ${props.CLIENT_UID}@${props.CLIENT_IP}:TestScripts/TestServerConnectivity.sh"
          sh "sshpass -p ${props.SERVER_PWD} ssh  -o 'StrictHostKeyChecking=no' ${props.SERVER_UID}@${props.SERVER_IP} webserver/TestServerConnectivity.sh"
          sh "sshpass -p ${props.CLIENT_PWD} ssh  -o 'StrictHostKeyChecking=no' ${props.CLIENT_UID}@${props.CLIENT_IP} TestScripts/TestServerConnectivity.sh ${props.SERVER_IP}"
        }

      }
    }
  }
  parameters {
    choice(choices: '''greeting
silence''', description: '', name: 'REQUESTED_ACTION')
  }
}
