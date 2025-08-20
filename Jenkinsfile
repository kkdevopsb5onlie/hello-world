pipeline {
    agent {
        label 'jenkins-agent'
    }
    tools {
        maven 'maven'
        sonarScanner 'sonar-scanner'
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
                    sh "sonar-scanner --version"
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

