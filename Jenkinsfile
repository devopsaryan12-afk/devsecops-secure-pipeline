pipeline {

    agent { label 'worker-node' }

    environment {
        DOCKER_IMAGE       = "aryandevops77/devsecops-node-app"
        IMAGE_TAG          = "${BUILD_NUMBER}"
        DOCKER_CREDENTIALS = "dockerhub-creds-id"
        EC2_CREDENTIALS    = "ec2-ssh-creds-id"
        CONTAINER_NAME     = "devsecops-app"
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Get EC2 Public IP') {
            steps {
                script {
                    EC2_PUBLIC_IP = sh(
                        script: "cd terraform && terraform output -raw production",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('app') {
                    sh 'npm ci'
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
                        ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} '
                            docker pull $DOCKER_IMAGE:$IMAGE_TAG &&
                            docker stop $CONTAINER_NAME || true &&
                            docker rm $CONTAINER_NAME || true &&
                            docker run -d \
                                --name $CONTAINER_NAME \
                                -p 80:8000 \
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
            echo "Pipeline executed successfully."
        }

        failure {
            echo "Pipeline failed. Fix Terraform or deployment errors."
        }
    }
}