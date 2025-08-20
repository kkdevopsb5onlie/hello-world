pipeline {
    agent {
        label 'jenkins-agent'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
    }
    tools {
        maven 'maven'
    }
    stages {
        stage('Test') {
            steps {
                script {
                   withCredentials([file(credentialsId: 'settings-xml-file', variable: 'MAVEN_SETTINGS')]) {
                      sh "mvn test -s $MAVEN_SETTINGS"
                    }
                }
            }
        }
        stage ('Sonarqube Analysis') {
            steps {
                script {
                    def SONAR_SCANNER_HOME = tool 'sonar-scanner'
                    sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner --version"
                    withSonarQubeEnv('sonar') {
                        sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectKey=hello-world"
                    }
                }
            }
        }
        stage ('Trivy scan') {
            steps {
                script {
                    sh " trivy fs --format json --output trivy-fs-report.json ."
                    archiveArtifacts artifacts: 'trivy-fs-report.json', fingerprint: true
                }
            }
        }
        stage ('Build') {
            steps {
                script {
                    sh "mvn package"
                }
            }
        }
        stage ('Publing artifacts into nexus') {
            steps {
                script {
                     withCredentials([file(credentialsId: 'settings-xml-file', variable: 'MAVEN_SETTINGS')]) {
                      sh "mvn deploy -s $MAVEN_SETTINGS"
                    }
                }
            }
        }
        stage('Building Image') {
            steps {
                script {
                    def TAG = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
                    env.IMAGE_TAG = TAG
                    sh "docker build -t dharimigariarjun/maven-project:${env.IMAGE_TAG} ."
                }
            }
        }
        stage ('Trivy Image scan') {
            steps {
                script {
                    sh "trivy image --format json dharimigariarjun/maven-project:${env.IMAGE_TAG} | tee trivy-image-report.json"
                    archiveArtifacts artifacts: 'trivy-image-report.json', fingerprint: true
                }
            }
        }
        stage ('Pushing image'){
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                      sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                      sh "docker push dharimigariarjun/maven-project:${env.IMAGE_TAG}"
                  }
                }
            }
        }
    }
    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()   // Jenkins Workspace Cleanup plugin
        }
    }
}


