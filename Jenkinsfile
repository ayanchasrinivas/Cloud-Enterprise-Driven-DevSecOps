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

        stage('SCM Debug') {
            steps {
                sh '''
                    echo "===== Git Remote ====="
                    git remote -v

                    echo "===== Current Branch ====="
                    git branch -a

                    echo "===== HEAD ====="
                    git rev-parse HEAD

                    echo "===== Last Commit ====="
                    git log --oneline -1

                    echo "===== Remote Branches ====="
                    git ls-remote --heads origin
                '''
            }
        }

        stage('Git Debug') {
            steps {
                sh '''
                    git status
                    git branch
                    git rev-parse HEAD
                    git ls-tree -r --name-only HEAD
                '''
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