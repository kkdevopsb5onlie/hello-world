pipeline {
    agent any 
    environemnt {
        
    }
    tools {
        maven 'maven'
    }
    parameters {
        
    }
    stages {
        stage ('git checkout'){
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/kkdevopsb5onlie/hello-world.git'
                }
            }
        }
        stage ("unit test"){
            steps {
                script {
                    sh "mvn test"
                }
            }
            
        }
        
    }
}

