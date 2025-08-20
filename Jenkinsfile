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
                    sh " trivy fs --format table --output trivy-fs-report.txt ."
                    archiveArtifacts artifacts: 'trivy-fs-report.txt', fingerprint: true
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
                    sh "trivy image --format table --output trivy-image-report.txt dharimigariarjun/maven-project:${env.IMAGE_TAG}"
                    archiveArtifacts artifacts: 'trivy-image-report.txt', fingerprint: true
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


