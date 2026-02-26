## 🧭 Project Roadmap

- ✅ Phase 1 — Application Development & Containerization
- 🔐 Phase 2 — Security Scanning Integration
- ⚙️ Phase 3 — CI/CD Pipeline (Jenkins)
- 🧪 Phase 4 — Automated Testing
- ☁️ Phase 5 — Infrastructure as Code (Terraform + AWS)
- 📊 Phase 6 — Monitoring & Observability


## 🚀 Phase 1 — Application Development & Containerization

### 🎯 Objective
Build and containerize a secure Node.js application as the foundation for a production-style DevSecOps pipeline.

### 🧱 Implemented Features
- Structured Node.js application with modular architecture
- Health check endpoint for service monitoring
- Production-ready Docker container
- Non-root user inside container for improved security
- Clean project structure separating application, docker, and pipeline layers
- Environment-independent reproducible build

### 📁 Project Structure (Phase 1)
app/
 └── src/
     └── server.js
jenkins/
Dockerfile
security/
test/

### 🐳 Run Application Locally

```bash
cd app
npm install
npm start

#### Application runs on
http://localhost:8000

#### Commands to build and run docker image
docker build -t devsecops-node-app -f docker/Dockerfile .
docker run -p 8000:8000 devsecops-node-app

#### Example Expected output
{
    "message": "DevSecOps Pipeline Running",
    "hostname": "LAPTOP-HFD3BCDR",
    "timestamp": "2026-02-11T17:15:42.335Z"
}
```

## DevSecOps Secure Pipeline – Phase 2 Update

## Overview

This repository contains the updated **Phase 2 implementation** of the DevSecOps secure CI/CD pipeline for our Node.js application.  

In Phase 2, the pipeline is executed **locally inside the Jenkins container**, without using any Jenkins agents. All stages run on the same environment, and workspace cleanup is performed at the start of each run.

> ⚠️ **Note:** Jenkins agents will be introduced in Phase 3 for isolated and scalable builds. Phase 2 focuses on local execution only.

---

## Pipeline Stages (Phase 2)

1. **Cleaning Workspace**  
   - Removes any existing files in the Jenkins workspace to start fresh.

2. **Checkout**  
   - Clones the repository from GitHub into the Jenkins workspace.

3. **Install Dependencies**  
   - Runs `npm ci` (or `npm install` if lockfile issues) inside `app/` to install Node.js dependencies.

4. **Dependency Scan**  
   - Runs `npm audit --audit-level=high` to detect high-severity vulnerabilities.

5. **Build Docker Image**  
   - Builds a Docker image of the Node.js application using the `Dockerfile`.

6. **Image Scan**  
   - Scans the Docker image for vulnerabilities using Trivy.

---

## Prerequisites

- Jenkins installed and running.
- Node.js installed in the Jenkins container.
- Docker installed in the Jenkins container.
- Trivy installed in the Jenkins container.

---

## How to Run Phase 2

1. Log into the Jenkins container.
2. Use the updated Jenkinsfile for Phase 2.
3. Run the pipeline — all stages will execute **locally**, without any external agent.

---


---

## Notes

- Workspace cleanup ensures a fresh environment for every pipeline run.  
- Phase 3 will introduce Jenkins agents for improved isolation and scalability.

Phase 3 focuses on:

- Jenkins Master–Worker architecture
- Secure pipeline execution on worker node
- Dependency vulnerability scanning
- Docker image build process
- Container image vulnerability scanning
- EC2 automation using User Data scripts

------------------------------------------------------------

# Phase 3 Objectives

1. Configure Jenkins Master on EC2
2. Attach Jenkins Worker Node via SSH
3. Execute pipeline on worker node
4. Perform Node.js dependency scan
5. Build Docker image
6. Scan Docker image for vulnerabilities
7. Automate infrastructure setup using EC2 User Data

------------------------------------------------------------

# Architecture (Phase 3)

GitHub Repository  
        ↓  
Jenkins Master (EC2)  
        ↓ SSH Connection  
Jenkins Worker (EC2)  
        ↓  
Pipeline Execution on Worker  

All build and security stages run on the worker node.

------------------------------------------------------------

# Project Structure (Phase 3)

.
├── app/
│   ├── package.json
│   ├── package-lock.json
│   └── server.js
├── Dockerfile
├── Jenkinsfile
└── README.md

------------------------------------------------------------

# CI/CD Pipeline Stages — Phase 3

Stage 1 — Checkout  
Clones source code from GitHub.

Stage 2 — Install Dependencies  
npm ci

Stage 3 — Dependency Vulnerability Scan  
npm audit --audit-level=high

Stage 4 — Build Docker Image  
docker build -t devsecops-node-app .

Stage 5 — Docker Image Scan  
Trivy container image scan for high and critical vulnerabilities.

------------------------------------------------------------

# Jenkins Setup — Phase 3

## Jenkins Master (EC2)

Responsibilities:
- Pipeline orchestration
- GitHub integration
- Agent management

Installed:
- Java 17
- Jenkins

------------------------------------------------------------

## Jenkins Worker Node (EC2)

Responsibilities:
- Execute all pipeline stages
- Run Node.js commands
- Build Docker images
- Perform vulnerability scans

Installed:
- Java 17
- Docker
- Node.js 18

------------------------------------------------------------

# EC2 User Data Script — Jenkins Master (Phase 3)
```bash
#!/bin/bash
yum update -y

yum install -y java-17-amazon-corretto
yum install -y git

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

yum install -y jenkins

systemctl enable jenkins
systemctl start jenkins
```
------------------------------------------------------------

# EC2 User Data Script — Jenkins Worker (Phase 3)
```bash
#!/bin/bash
yum update -y

yum install -y java-17-amazon-corretto

yum install -y docker
systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user

curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs
```
------------------------------------------------------------

# Security Implementation in Phase 3

- Node dependency scanning using npm audit
- Container image scanning using Trivy
- Master–Worker isolation
- SSH secured agent communication
- No direct builds on Jenkins master

------------------------------------------------------------

# Outcome of Phase 3

- Secure CI pipeline operational
- Worker node successfully attached
- Automated infrastructure provisioning
- Integrated DevSecOps practices into build lifecycle

------------------------------------------------------------
# DevSecOps Secure Pipeline — Phase 4

## Objective

Phase 4 focuses on implementing Continuous Deployment (CD) by introducing a separate Production EC2 instance.
The goal is to extend the CI pipeline from Phase 3 into a secure, automated deployment workflow.

---

# Phase 4 Goals

- Integrate Docker Hub as a container registry
- Push scanned images to Docker Hub
- Deploy application to a separate Production EC2 instance
- Automate deployment using Jenkins
- Maintain environment isolation (CI vs Production)
- Follow secure credential management practices

---

# Target Architecture

GitHub  
↓  
Jenkins Master (EC2)  
↓  
Jenkins Worker (Build + Scan)  
↓  
Docker Hub (Image Registry)  
↓  
Production EC2 (Deployment Server)

---

# Infrastructure Plan

## 1. Production EC2 Instance

Purpose:
- Host running application container
- Act as production environment

Configuration:
- Amazon Linux 2
- Docker installed
- Port 22 (SSH access restricted to Jenkins Worker)
- Port 80 (or 3000) open for application access

User Data Script Plan:
```bash

#!/bin/bash

# Update system
yum update -y

# Install Docker
yum install -y docker

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Install useful utilities (optional but recommended)
yum install -y git curl

# Create app directory
mkdir -p /opt/app
chown ec2-user:ec2-user /opt/app

# Enable docker to start on reboot
systemctl enable docker

# Log completion
echo "Production server setup complete" > /var/log/user-data.log
```
---

# Jenkins Configuration Plan

## 1. Docker Hub Credentials

- Store credentials in Jenkins Credentials Manager
- Type: Username & Password
- ID: dockerhub-creds

## 2. Production SSH Key

- Store private key securely in Jenkins
- Type: SSH Username with Private Key
- ID: prod-ec2-key
- Username: ec2-user

No credentials will be hardcoded in the Jenkinsfile.

---

# Pipeline Extension Plan

New stages to be added after successful security scans:

## Stage 1 — Push Image to Docker Hub

Steps:
- Login using Jenkins credentials
- Tag image using BUILD_NUMBER
- Push image to Docker Hub
- Logout

Image tagging strategy:
devsecops-node-app:${BUILD_NUMBER}

This ensures:
- Version tracking
- Traceability
- Rollback capability

---

## Stage 2 — Deploy to Production EC2

Steps:
- SSH into production server using Jenkins ssh-agent
- Stop existing container (if running)
- Remove old container
- Pull latest versioned image
- Run new container with port mapping

Deployment strategy:
Recreate deployment (simple and clean for Phase 4)

---

# Security Considerations

- Build and scan happen only on Worker node
- Production server does not contain source code
- Image is scanned before push
- No plaintext credentials
- SSH key-based authentication only
- CI and Production environments are isolated

---

# Rollback Strategy (Planned)

Because images are versioned using BUILD_NUMBER:

To rollback:
- SSH into production server
- Run previous image tag manually

Future improvement:
Automate rollback stage in Jenkins (Phase 5 enhancement)

---

# Expected Outcome of Phase 4

After implementation:

- Fully automated CI/CD pipeline
- Secure image registry integration
- Separate production environment
- Deployment triggered automatically after successful build
- Version-controlled Docker releases

---

# Future Enhancements (Beyond Phase 4)

- Blue/Green deployment strategy
- Docker Compose in production
- Nginx reverse proxy
- HTTPS with Let's Encrypt
- Kubernetes migration
- Automated rollback stage


# Phase 5 – Infrastructure Foundation with Terraform

## 📌 Objective

In this phase, we introduce Infrastructure as Code using **Terraform**.

The goal is to build a production-style AWS networking foundation that will support Kubernetes in the next phase.

> ⚠️ No application workloads are deployed in this phase.  
> This phase focuses strictly on cloud infrastructure fundamentals.

---

## 🎯 What We Are Building

Using Terraform, we provision:

- Custom VPC
- 2 Public Subnets (across 2 Availability Zones)
- 2 Private Subnets (across 2 Availability Zones)
- Internet Gateway
- NAT Gateway (single, cost-optimized)
- Route Tables and associations
- Base Security Group

This infrastructure will later support Amazon EKS in Phase 6.

---

## 🏗 Architecture Overview

```
VPC (10.0.0.0/16)
│
├── Public Subnet (AZ1)
├── Public Subnet (AZ2)
│
├── Private Subnet (AZ1)
└── Private Subnet (AZ2)
```

### Public Subnets
- Internet Gateway attached
- NAT Gateway deployed here
- Used for public-facing resources

### Private Subnets
- Outbound internet access via NAT Gateway
- Future EKS worker nodes will run here

---

## 📂 Project Structure

```
project-root/
│
├── app/
├── docker/
├── terraform/
│   ├── providers.tf
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars
│
└── Jenkinsfile
```

All infrastructure code resides inside the `terraform/` directory.

---

## 🔄 CI Integration Strategy

Terraform is integrated into the existing Jenkins pipeline.

### Updated Pipeline Flow

1. Checkout Code  
2. Terraform Init  
3. Terraform Plan  
4. Docker Build  
5. Security Scan  

> ⚠️ `terraform apply` is NOT automated in this phase.  
> Infrastructure changes must be applied manually to avoid accidental resource creation.

---

## 🔐 AWS Authentication Strategy

Terraform runs on the Jenkins Worker EC2 instance.

Authentication method:

- IAM Role attached to Jenkins Worker EC2
- No hardcoded AWS access keys
- No credentials stored in repository

This follows secure infrastructure practices.

---

## 🚀 Execution Commands (Manual Apply)

SSH into Jenkins Worker:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

To destroy infrastructure:

```bash
terraform destroy
```

---

## 🧠 Why This Phase Matters

This phase establishes:

- AWS networking fundamentals
- Public vs Private subnet separation
- NAT routing logic
- Infrastructure lifecycle management
- Terraform state handling
- CI integration for infrastructure validation

Skipping this layer often leads to shallow Kubernetes understanding.

---

## 📌 Important Rules

- Default VPC is NOT used
- No manual changes via AWS Console
- Infrastructure must be reproducible
- All networking resources are defined in code

---

## 🔮 What Happens in Phase 6

In the next phase, we will:

- Provision an EKS cluster using Terraform
- Create worker node groups
- Deploy the application into Kubernetes
- Expose the application via LoadBalancer

That is where workload orchestration begins.

---

## ✅ Learning Outcomes

After completing this phase, you will understand:

- VPC architecture design
- Availability Zone distribution
- Subnet routing behavior
- NAT Gateway setup
- Infrastructure validation in CI pipelines
- Terraform execution lifecycle

---

**Phase 5 builds the foundation.  
Phase 6 builds the platform.**
---
Author  
Aryan Gupta  
DevOps | Cloud | DevSecOps
Enhanced By ChatGPT

