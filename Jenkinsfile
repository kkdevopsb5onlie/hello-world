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
                    sh "mvn test"
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
                     withCredentials([file(credentialsId: 'maven-settings-file', variable: 'MAVEN_SETTINGS')]) {
                      sh "mvn clean install --settings $MAVEN_SETTINGS"
                    }
                }
            }
        }
    }
}


