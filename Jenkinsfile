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
                    ansiColor('xterm') {
                    echo "\u001B[32m STARTED CLONING REPOSITORY !\u001B[0m"
                    }
                    git branch: 'feature/nexus', url: 'https://github.com/kkdevopsb5onlie/hello-world.git'
                }
            }
        }
        stage ("unit test"){
            steps {
                script {
                    ansiColor('xterm') {
                      echo "\u001B[32m  ####### STARTED UNIT TEST! #########\u001B[0m"
                    }
                    sh "mvn test"
                }
            }
            
        }
        stage ('build') {
            steps {
                script {
                   ansiColor('xterm') {
                      echo "\u001B[32m  ####### STARTED BUILDING APPLICAION #########\u001B[0m"
                    }
                    sh "mvn package"
                }
            }
        }
        stage ('Building image') {
            steps {
                script {
                  ansiColor('xterm') {
                      echo "\u001B[32m  ####### STARTED BUINDING DOCKER IMAGE! #########\u001B[0m"
                    }
                    sh "docker build -t ${AWS_ECR_REPO_URL}/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER} ."
                }
            }
        }
        stage ('trivy image scanning'){
            steps {
                script {
                try {
                       ansiColor('xterm') {
                         echo "\u001B[32m  ####### STARTED TRIVY IMAGE SCANNING! #########\u001B[0m"
                       }
                       sh "trivy image -f json -o trivy-image-report.json ${AWS_ECR_REPO_URL}/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}"
                       archiveArtifacts artifacts: 'trivy-image-report.json', fingerprint: true
                       ansiColor('xterm') {
                        echo "\u001B[32m  ####### COMPLETED TRIVY IMAGE SCANNING SUCCESSFULLY COMPLETED #########\u001B[0m"
                      }
                } catch (Exception e ) {
                        println("THis stage failed due to storage issue. So contiouing next stage")
                }
             }
            }
        }    
        stage ('Pushing image inot ecr') {
            steps {
                script {
                    ansiColor('xterm') {
                      echo "\u001B[32m  ####### LOGGING INTO AWS ECR REGISTRY ! #########\u001B[0m"
                    }
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                        //export AWS_DEFAULT_REGION=eu-north-1
                        sh """
                        aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 965220894814.dkr.ecr.eu-north-1.amazonaws.com
                        docker push ${AWS_ECR_REPO_URL}/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}
                        sh """
                    }
                }
            }
        }
        stage ('Deploying application') {
            steps {
                script {
                    ansiColor('xterm') {
                      echo "\u001B[32m  ####### STARTED DEPLOYING APPLICATION ! #########\u001B[0m"
                    }
                    sh "docker rm -f test-application"
                    sh "docker run -itd --name test-application -p 8091:8080 ${AWS_ECR_REPO_URL}/${AWS_ECR_REPO_NAME}:${BUILD_NUMBER}"
                    println("${GIT_URL}")
                }
            }
        }
    }
}

