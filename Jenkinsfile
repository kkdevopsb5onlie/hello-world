pipeline {
    agent any
     triggers {
        cron('* * * * *')  // Runs every 15 minutes
    }
    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
