pipeline {
    agent {
        label "linuxbuildslave"
    }

    stages{

        stage('SCM stage'){
          steps{
           git 'https://github.com/vimallinuxworld13/jenkins-docker-maven-java-webapp.git'
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

