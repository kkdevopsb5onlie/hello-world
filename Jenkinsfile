@Library('shared_libraries@main') _

pipeline {
    agent any
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
