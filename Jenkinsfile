pipeline {
  agent any
  environment {
    def props = readJSON file: 'TestData.json'
  }
        
        
 
  stages {
    stage('Deploy') {
      steps {
        script{
            curl_url = "http://192.168.60.149/cgi-bin/luci/rpc/auth --data " 
            curl_params =  '\'{"id": 1,"method":"login","params":["root",""]}\''
            curl_cmd = 'curl -s ' + curl_url + curl_params
            sh '''
                IP=\$(${curl_cmd})"
                echo "$IP"
            '''
            
        }
        
      }
    }
    
    
    stage('Prepare For Test') {
      steps{
        script{
          props = readJSON file: 'TestData.json'
          props.CLIENT_PWD = "\'" + props.CLIENT_PWD + "\'"
        }
        
        sh "sshpass -p ${props.CLIENT_PWD} scp  -o 'StrictHostKeyChecking=no' TestServerConnectivity.sh ${props.CLIENT_UID}@${props.CLIENT_IP}:TestScripts/TestServerConnectivity.sh"
        sh "sshpass -p ${props.SERVER_PWD} ssh  -f -o 'StrictHostKeyChecking=no' ${props.SERVER_UID}@${props.SERVER_IP} webserver/StartWebServerOneTimeListen.sh"        
      }
    }
    
    stage('Test') {
      steps {
        sh "sshpass -p ${props.CLIENT_PWD} ssh  -o 'StrictHostKeyChecking=no' ${props.CLIENT_UID}@${props.CLIENT_IP} TestScripts/TestServerConnectivity.sh ${props.SERVER_IP}"        
      }
    }
    
  }
  
    post {
        always {
            echo 'One way or another, I have finished'
           /* deleteDir() /* clean up our workspace */
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
