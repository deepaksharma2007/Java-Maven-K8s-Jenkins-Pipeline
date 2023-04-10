pipeline {
    agent {
        label "linuxbuildslave"
    }

    stages{

        stage('SCM stage'){
          steps{
           git 'https://github.com/deepaksharma2007/Java-Maven-K8s-Jenkins-Pipeline.git'
           echo 'Code downloaded....' 
        }
    }

    stage('Build Stage Maven'){
          steps{
           sh 'mvn clean package'
           echo 'Maven build the code...' 
        }
    }

     stage('Create Docker OWN Image'){
          steps{
           sh "sudo docker build -t deepak2007/auto-java-tomcat-jenkins:${BUILD_TAG} . "
           echo 'Docker images is created successfully...' 
        }
    }

     stage('Push Docker Image to Registry'){
          steps{
              withCredentials([string(credentialsId: 'Docker_Hub_pass', variable: 'DOCKER_HUB_PASS')]) {
    		// some block
                  sh "sudo docker login -u deepak2007  -p $DOCKER_HUB_PASS"
                  sh "sudo docker push deepak2007/auto-java-tomcat-jenkins:${BUILD_TAG}"
           }
        }
    }

     stage('Deploy WebApp in DEV ENV'){
          steps{
           sh "sudo docker rm -f myjavapp "
           sh "sudo docker run -d --name myjavapp -p 8080:8080  deepak2007/auto-java-tomcat-jenkins:${BUILD_TAG} "  
   		}
  	}
       stage('Deploy webapp in QAT'){
          steps{
              sshagent(['QAT_CRED']) {
             // some block
              sh "ssh -o StrictHostKeyChecking=no ec2-user@13.126.136.162  sudo docker rm -f myjavapp "
              sh "ssh ec2-user@13.126.136.162  sudo docker run -d --name myjavapp -p 8080:8080  deepak2007/auto-java-tomcat-jenkins:${BUILD_TAG} "
            }
          }  
    }
    
     stage('QAT Testing'){
         steps{
             retry(10){
             sh 'curl --silent http://13.126.136.162:8080/java-web-app/ |  grep India'
         }}
     }
    
     stage('approval') {
         steps{
             input(message: "do you want to release into Prod ??")
         }
     }

     stage('Deploy to PROD ENV'){
         steps{
            
             sshagent(['PROD_ENV_PASS']) {
            // some block
                 sh "ssh -o StrictHostKeyChecking=no ec2-user@43.205.253.178  sudo docker rm -f myjavapp "
                sh "ssh ec2-user@43.205.253.178  sudo docker run -d --name myjavapp -p 8080:8080  deepak2007/auto-java-tomcat-jenkins:${BUILD_TAG} "
                 
             }
         }
    }
}
}

