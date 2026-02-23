pipeline {

    agent { label 'worker-node' }

    environment {
        DOCKER_IMAGE      = "aryandevops77/devsecops-node-app"
        IMAGE_TAG         = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = "dockerhub-creds-id"
        EC2_CREDENTIALS    = "ec2-ssh-creds-id"
        EC2_HOST           = "ec2-user@13.233.74.179"
        CONTAINER_NAME     = "devsecops-app"
    }

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
                sh """
                    docker build -t $DOCKER_IMAGE:$IMAGE_TAG .
                    docker tag $DOCKER_IMAGE:$IMAGE_TAG $DOCKER_IMAGE:latest
                """
            }
        }

        stage('Image Scan (Trivy)') {
            steps {
                sh """
                    docker run --rm \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy image \
                    --exit-code 1 \
                    --severity HIGH,CRITICAL \
                    $DOCKER_IMAGE:$IMAGE_TAG
                """
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKER_CREDENTIALS,
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh """
                    docker push $DOCKER_IMAGE:$IMAGE_TAG
                    docker push $DOCKER_IMAGE:latest
                """
            }
        }

        stage('Deploy to Production EC2') {
            steps {
                sshagent([EC2_CREDENTIALS]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no $EC2_HOST '
                            docker pull $DOCKER_IMAGE:$IMAGE_TAG &&
                            docker stop $CONTAINER_NAME || true &&
                            docker rm $CONTAINER_NAME || true &&
                            docker run -d \
                                --name $CONTAINER_NAME \
                                -p 80:3000 \
                                --restart always \
                                $DOCKER_IMAGE:$IMAGE_TAG
                        '
                    """
                }
            }
        }
    }

    post {
        always {
            sh "docker rmi $DOCKER_IMAGE:$IMAGE_TAG || true"
        }

        success {
            echo "Phase 4 CI/CD pipeline executed successfully."
        }

        failure {
            echo "Pipeline failed. Fix vulnerabilities or deployment errors."
        }
    }
}