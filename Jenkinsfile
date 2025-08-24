@Library('shared_libraries@main') _

pipeline {
    agent any
    tools {
        maven 'maven'
    }
    stages {
        stage('test') {
            steps {
               script {
                   maven_test('setting-xml-file-creds')
               }
            }
        }
    }
}
