pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
        CLUSTER_NAME = "devsecops-eks-cluster"
        IMAGE_NAME = "aryandevops77/devsecops-node-app"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Terraform Init & Apply (EKS)') {
            steps {
                dir('terraform') {
                    sh '''
                    terraform init
                    terraform validate
                    terraform plan
                    terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Update Kubeconfig') {
            steps {
                sh '''
                aws eks update-kubeconfig \
                  --region $AWS_DEFAULT_REGION \
                  --name $CLUSTER_NAME
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                # Update image dynamically
                sed -i "s|IMAGE_PLACEHOLDER|$IMAGE_NAME:$IMAGE_TAG|g" k8s/deployment.yaml

                kubectl apply -f k8s/deployment.yaml
                kubectl apply -f k8s/service.yaml

                kubectl rollout status deployment/devsecops-app
                '''
            }
        }
    }
}
