pipeline {
    agent any
    environment {
        SONARQUBE = 'SonarQube'
    }

    stages {
        stage('checkout') {
            steps {
                git 'https://github.com/ayanchasrinivas/Cloud-Enterprise-Driven-DevSecOps.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    echo "Current Directory:"
                    pwd

                    echo "Workspace:"
                    ls -la

                    echo "Repository Structure:"
                    find . -maxdepth 3
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('vulnerable-app') {
                    withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=vulnerable-app
                    '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }

    post {
        success {
            echo 'Build Passed!'
        }

        failure {
            echo 'Build Failed!'
        }
    }
}