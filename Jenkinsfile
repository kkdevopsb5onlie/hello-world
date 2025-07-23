pipeline {
    agent any
     triggers {
        pollSCM(('* * * * *')  // Runs every 15 minutes
    }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
