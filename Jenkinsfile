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
        stage ('Trivy file scan') {
            steps {
                script {
                    trivy_scan_with_source_code( 
                        outputFile : 'trivy-file-scan-reports.json',
                        format : 'json',
                        scanPath : '.'
                    )
                }
            }
        }
                    
    }
}
