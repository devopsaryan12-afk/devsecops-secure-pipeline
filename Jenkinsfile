pipeline {

    agent { label 'worker-node' }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('app') {
                    sh 'npm ci'
                }
            }
        }

        stage('Node Vulnerability Scan') {
            steps {
                dir('app') {
                    sh 'npm audit --audit-level=high'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t devsecops-node-app .'
            }
        }

        stage('Image Scan (Trivy)') {
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
