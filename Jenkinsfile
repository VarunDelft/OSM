pipeline {
  agent any
  environment {
    props = readJSON file: 'TestData.json'
  }
        
        
 
  stages {
    stage('Deploy') {
      steps {
        sh "sshpass -p admin123 scp -P 8722 -o 'StrictHostKeyChecking=no' FirewallConfig osmadmin@192.168.60.215:LocalConfigCache/FirewallConfig" 
        
        
      }
    }
    
    
    stage('Prepare For Test') {
      steps{
        script{
          
          props.CLIENT_PWD = "\'" + props.CLIENT_PWD + "\'"
        }
        
        sh "sshpass -p ${props.CLIENT_PWD} scp  -o 'StrictHostKeyChecking=no' TestServerConnectivity.sh ${props.CLIENT_UID}@${props.CLIENT_IP}:TestScripts/TestServerConnectivity.sh"
        sh "sshpass -p ${props.SERVER_PWD} ssh  -o 'StrictHostKeyChecking=no' ${props.SERVER_UID}@${props.SERVER_IP} webserver/TestServerConnectivity.sh"        
      }
    }
    
    stage('Test') {
      steps {
        sh "sshpass -p ${props.SERVER_PWD} ssh  -o 'StrictHostKeyChecking=no' ${props.SERVER_UID}@${props.SERVER_IP} webserver/TestServerConnectivity.sh"        
      }
    }
    
  }
  
    post {
        always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
        }
        success {
            echo 'I succeeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
    }
}
