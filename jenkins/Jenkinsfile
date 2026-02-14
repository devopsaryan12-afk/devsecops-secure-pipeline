pipeline {
    agent any

    stages {
        stage('Cleaning Workspace') {
            steps {
                deleteDir()
            }
        }
    
        stage('Checkout') {
            steps {
                sh 'git clone https://github.com/devopsaryan12-afk/devsecops-secure-pipeline.git/'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('devsecops-secure-pipeline/app') {
                    sh 'npm ci'
                }
            }
        }

        stage('Dependency Scan') {
            steps {
                dir('devsecops-secure-pipeline/app') {
                    sh 'npm audit --audit-level=high'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('devsecops-secure-pipeline') {
                    sh 'docker build -t devsecops-node-app .'
                }
            }
        }

        stage('Image Scan') {
            steps {
                sh 'trivy image devsecops-node-app'
            }
        }
    }
}