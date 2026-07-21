pipeline {
    agent any
    environment {
        SONARQUBE = 'SonarQube'
    }

    stages {
        stage('checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ayanchasrinivas/Cloud-Enterprise-Driven-DevSecOps.git'
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
                dir('vulnerable-app') {
                    sh 'mvn clean verify'
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                dir('vulnerable-app') {
                    withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn clean verify \
                        org.sonarsource.scanner.maven:sonar-maven-plugin:4.0.0.4121:sonar \
                        -Dsonar.projectKey=vulnerable-app
                    '''
                    }
                }
            }
        }

        stage('Trivy Filesystem Scan') {
            steps{
                dir('vulnerable-app') {
                    sh '''
                        trivy fs \
                            --scanners vuln,secret,misconfig \
                            --severity HIGH,CRITICAL \
                            --exit-code 1 \
                            .
                    '''
                    sh '''
                        trivy fs \
                        --format json \
                        -o trivy-report.json \
                        .
                    '''
                    sh '''
                        trivy fs \
                        --format template \
                        --template "@/usr/local/share/trivy/templates/html.tpl" \
                        -o trivy-report.html \
                        .
                    '''
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'vulnerable-app/trivy-report.*', fingerprint: true
                }
            }
        }

        stage('Generate SBOM') {
            steps {
                dir('vulnerable-app') {
                    sh '''
                        mvn org.cyclonedx:cyclonedx-maven-plugin:2.9.2:makeAggregateBom
                    '''
                }
            }
        }

        // stage('Quality Gate') {
        //     steps {
        //         timeout(time: 5, unit: 'MINUTES') {
        //             waitForQualityGate abortPipeline: true
        //         }
        //     }
        // }
    }

    post {
        success {
            echo 'Build Passed!'
        }

        failure {
            echo 'Build Failed!'
        }

        always {
            archiveArtifacts artifacts: '''
                vulnerable-app/target/bom.xml,
                vulnerable-app/target/bom.json
            ''', fingerprint: true
        }
    }
}