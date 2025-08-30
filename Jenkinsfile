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
        stage ('Pushing artifacts into nexus') {
            steps {
                script {
                    maven_publish_artifacts('setting-xml-file-creds')
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
                        )
                    }
                }
           }
        stage ('Trivy scan image') {
            steps {
                script {
                    trivy_scan_image(
                        imageName : 'dharimigariarjun/maven-project',
                        format : 'json',
                        outputFile : 'my-trivy-image-scan-reports.json'
                    )
                }
            }
        }
        stage ('Pushing Image into Docker resitory') {
            steps {
                script {
                    pushing_image(
                        imageName : 'dharimigariarjun/maven-project',
                        credentialsId : 'docker-hub-credentials'
                        )
                }
            }
        }
        stage ('deploy') {
            steps {
                script {
                    deploy_docker_container(
                        inboudPort_number : '9090',
                        outboundPort_number : '8080',
                        container_name : 'java-application',
                        image_name : 'dharimigariarjun/maven-project'
                        )
                }
            }
        }                 
    }
}
