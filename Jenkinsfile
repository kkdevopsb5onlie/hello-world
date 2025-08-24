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
        stage ('sonar analysis') {
            steps {
                script {
                    sonar_analysis(
                        toolName : 'sonarqube-scanner',
                        sonarEnv : 'sonar',
                        projectKey : 'hello-word'
                    )
                }
            }
        }
        stage ('build') {
            steps {
                script {
                    maven_build('setting-xml-file-creds')

                }
            }
        }
        stage ('building image') {
            steps {
                script {
                    building_image(
                        imageName : 'dharimigariarjun/maven-project',
                        dockerfile : 'Dockerfile',
                        buildContext : '.'
                    }
                }
           }
                        
    }
}
