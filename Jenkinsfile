pipeline {
  agent any
  environment {
	
    def props = "abc" //readJSON file: 'Test/TestData.json'
    def InstanceNameJson = readJSON file: 'ChangeInstance'
	//def InstanceName = "abc"
	def propsconfig = "abc"
	def constants = "abc"
	
  }
        
        
 
  stages {
    
	stage ('Build'){
	steps{
		script{
			InstanceNameJson = readJSON file: 'ChangeInstance'
			InstanceName = InstanceNameJson.InstanceName
			propsconfig = readJSON file: "InstanceSpecific/" + InstanceName + "/FirewallConfig"
			cp = readJSON file: 'Data/ConfigData/OSMConfig.json'
			props = readJSON file: "InstanceSpecific/" + InstanceName + "/Data/InstanceData.json"
		}
		
	}
	}
	stage('Deploy') {
      steps {
           sh "bash  ./Scripts/ManageFirewallRule.sh ${props.FIREWALL_IP}  ${props.SERVER_INT_IP} ${propsconfig.mode}"
        
      }
    }
    
    
    stage('Prepare For Test') {
      steps{
        script{
          
          cp.CLIENT_PWD = "\'" + cp.CLIENT_PWD + "\'"
        }
        
        sh "sshpass -p ${cp.CLIENT_PWD} scp  -o 'StrictHostKeyChecking=no' Scripts/TestServerConnectivity.sh ${cp.CLIENT_UID}@${cp.CLIENT_IP}:TestScripts/TestServerConnectivity.sh"
        sh "sshpass -p ${cp.SERVER_PWD} ssh  -f -o 'StrictHostKeyChecking=no' ${cp.SERVER_UID}@${props.SERVER_EXT_IP} webserver/StartWebServerOneTimeListen.sh"        
      }
    }
    
    stage('Test') {
      steps {
        sh "sshpass -p ${cp.CLIENT_PWD} ssh  -o 'StrictHostKeyChecking=no' ${cp.CLIENT_UID}@${cp.CLIENT_IP} TestScripts/TestServerConnectivity.sh  ${props.FIREWALL_IP} ${propsconfig.mode} "        
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
          sh "git mv InstanceSpecific/" + InstanceName +"/FirewallConfig InstanceSpecific/" + InstanceName +"/Archive/FirewallConfig_bk_`date '+%Y%m%d%H%M%S'`"
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
