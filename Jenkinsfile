pipeline {
  agent any
  environment {
    def props = readJSON file: 'TestData.json'
    def propsconfig = readJSON file: 'FirewallConfig'
  }
        
        
 
  stages {
    stage('Deploy') {
      steps {
        script{
            propsconfig = readJSON file: 'FirewallConfig' 
            
        }
        sh "./ManageFirewallRule.sh ${propsconfig.FirewallIP}  ${propsconfig.ServerIP} ${propsconfig.mode}"
        
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
        sh "sshpass -p ${props.CLIENT_PWD} ssh  -o 'StrictHostKeyChecking=no' ${props.CLIENT_UID}@${props.CLIENT_IP} TestScripts/TestServerConnectivity.sh  ${props.FIREWALL_IP} ${propsconfig.mode} "        
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
          sh "git mv FirewallConfig FirewallConfig_bk_`date '+%Y%m%d%H%M%S'`"
            sh "git commit -m 'abc'"
            sh   "git config remote.origin.url https://github.com/prodaptconsulting/OSM.git"
            sh "git config user.email 'jignesh.karnik@prodapt.com'"
            sh "git config user.name 'prodaptconsulting'"
            sh "git push 'https://prodaptconsulting:thisisgitadmin789\$@github.com/prodaptconsulting/OSM.git' master"
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
