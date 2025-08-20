pipeline {
    agent {
        label 'jenkins-agent'
    }
    tools {
        maven 'maven'
    }
    stages {
        stage('test') {
            steps {
                script {
                    sh "mvn test"
                }
            }
        }
        stage ('sonarqube analysis') {
            steps {
                script {
                    def SONAR_SCANNER_HOME = tool 'sonar-scanner'
                    sh "${SONAR_SCANNER_HOME}/bin/sonar-scanner --version"
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
    }
}

