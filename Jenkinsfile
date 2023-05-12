pipeline{
	agent any
	tools{
		maven 'M2_HOME'
		terraform 'TERRAFORM_HOME'
	}
        environment {
          DOCKERHUB_CREDENTIALS= credentials('dockerhubcredentials')
       }

	stages{
		stage('CheckOut the project'){
			steps {
				
				git branch: 'main', url: 'https://github.com/rajeswari69/medicureapp.git'
			}
		}
		stage('package the application'){
			steps{
			
				sh 'mvn clean package'
			}
		}
		stage('publish HTML report'){
			steps{
				publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/medicure/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
			}
		}
		stage('Build Docker Image'){
			steps{
				sh 'docker system prune -af '
				sh 'docker build -t rajeswari123/medicureapplication:latest .'
			}
		}
		stage('DockerLogin'){
			steps{

                              sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

                        } 

                }

		stage('push Image to DockerHub'){
			steps{
				sh 'docker push rajeswari123/medicureapplication:latest'
			}
		}
		
		stage('Terraform-stage'){
			steps{
		   	
					sh 'chmod 600 medicure.pem'
					sh 'terraform init'
					sh 'terraform validate'
					sh 'terraform apply -auto-approve'
				}
			}
		
		
		stage('Minikube installation'){
			steps{
			ansiblePlaybook credentialsId: 'ssh-key', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/medicure/inventory', playbook: 'deploy.yml'
			}
		}
                stage('Run Application on kubernetes'){
			steps{
				sh 'chmod 600 medicure.pem'    
				ansiblePlaybook credentialsId: 'ssh-key', disableHostKeyChecking: true, installation: 'ansible', inventory: '/var/lib/jenkins/workspace/medicure/inventory', playbook: 'deployApp.yml'
			}
		}
	
	}
}
