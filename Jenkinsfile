pipeline {
    agent any 
    environment {
        AWS_ECR_REPO_URL = "965220894814.dkr.ecr.eu-north-1.amazonaws.com"
        AWS_ECR_REPO_NAME =  "hello-world"
    }
    tools {
        maven 'maven'
    }
    /*parameters {
        
    }*/
    stages {
        stage ('git checkout'){
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/kkdevopsb5onlie/hello-world.git'
                }
            }
        }
        stage ("unit test"){
            steps {
                script {
                    sh "mvn test"
                }
            }
            
        }
        stage ('build') {
            steps {
                script {
                    sh "mvn package"
                }
            }
        }
        stage ('Building image') {
            steps {
                script {
                    sh "ls -la"
                    sh "docker build -t ${AWS_ECR_REPO_URL}/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
        stage ('Pushing image inot ecr') {
            steps {
                script {
                    println(" ############# logging into aws ecr ################# ")
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        sh """
                        export AWS_DEFAULT_REGION=eu-north-1
                        aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 965220894814.dkr.ecr.eu-north-1.amazonaws.com
                        docker push ${AWS_ECR_REPO_URL}/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
                        sh """
                    }
                }
            }
        }
    }
}

