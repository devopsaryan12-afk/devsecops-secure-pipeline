pipeline {

    agent { label 'worker-node' }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install & Dependency Scan') {
            agent {
                docker {
                    image 'node:18'
                }
            }
            steps {
                dir('app') {
                    sh 'npm ci'
                    sh 'npm audit --audit-level=high'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devsecops-node-app .'
            }
        }

        stage('Image Scan') {
            steps {
                sh '''
                docker run --rm \
                -v /var/run/docker.sock:/var/run/docker.sock \
                aquasec/trivy image devsecops-node-app
                '''
            }
        }
    }
}
