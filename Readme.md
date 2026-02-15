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

# 🚀 Phase 3 – Cloud-Based Distributed CI/CD Architecture

## 📌 Overview

Phase 3 upgrades the local Jenkins pipeline (Phase 2) into a cloud-hosted, distributed CI/CD system.

This phase introduces:

- Cloud infrastructure
- Jenkins Master–Agent separation
- Docker-based build execution
- Remote agent configuration
- Production-like CI architecture

Cloud Provider: Amazon Web Services (AWS)  
Compute Service: Amazon EC2  

---

# 🏗 Architecture

## 🔹 Infrastructure Layout

EC2 Instance #1 (Jenkins Master)
    └── Jenkins Controller
        └── Orchestrates pipelines only

EC2 Instance #2 (Build Agent Host)
    ├── Docker installed
    └── Jenkins Agent (Docker container)
            └── Builds Docker image
            └── Runs security scans
            └── Pushes image to registry
            └── Deploys container

---

# 🎯 Objectives

- Move CI/CD system from local machine to cloud
- Implement proper Master–Agent architecture
- Prevent builds from running on the controller
- Use containerized build environments
- Simulate production-grade infrastructure

---

# 🧱 Components

## 1️⃣ Jenkins Master (EC2 #1)

Responsibilities:
- Manage pipelines
- Store build history
- Assign jobs to agents
- Provide UI access

Design Principle:
- Lightweight
- No heavy build tasks
- No unnecessary tools installed

---

## 2️⃣ Jenkins Agent (EC2 #2)

Responsibilities:
- Execute all pipeline stages
- Build Docker images
- Perform vulnerability scans
- Push images to registry
- Deploy containers

Requirements:
- Docker installed
- Connected to Master via SSH or inbound agent
- Proper security group configuration

---

# 🔐 Networking & Security

Master EC2:
- Port 22 → SSH
- Port 8080 → Jenkins UI
- Restricted inbound access

Agent EC2:
- Port 22 → SSH from Master
- No public exposure required for builds

Best Practices:
- Use SSH key authentication
- Avoid hardcoded credentials
- Use IAM roles when possible

---

# 🐳 CI/CD Pipeline Flow

1. Developer pushes code to repository
2. Jenkins Master triggers pipeline
3. Job assigned to remote Agent
4. Agent executes:
   - Checkout source code
   - Install dependencies
   - Dependency vulnerability scan
   - Docker image build
   - Image vulnerability scan
   - Push to registry
   - Deploy container
5. Build logs stored on Master

---

# 🔄 Pipeline Stages

Stage 1  → Checkout Code  
Stage 2  → Install Dependencies  
Stage 3  → Dependency Scan  
Stage 4  → Docker Build  
Stage 5  → Image Scan  
Stage 6  → Push to Registry  
Stage 7  → Deploy Container  

All execution happens on the remote Agent, not on the Master.

---

# 📊 Improvements Over Phase 2

| Feature | Phase 2 | Phase 3 |
|----------|----------|----------|
| Hosting | Local machine | Cloud EC2 |
| Master runs builds | Yes | No |
| Distributed architecture | No | Yes |
| Cloud networking | No | Yes |
| Production-like design | Limited | Yes |
| Scalability | Limited | Expandable |

---

# 🚀 Implementation Plan

1. Launch two EC2 instances
2. Configure security groups
3. Install Docker on both
4. Deploy Jenkins on Master EC2
5. Configure Agent on second EC2
6. Connect Agent to Master
7. Update Jenkinsfile to use agent label
8. Execute full pipeline
9. Validate build and deployment

---

# ✅ Completion Criteria

- Jenkins accessible via EC2 public IP
- Agent visible and online in Jenkins
- Builds executed on Agent (not Master)
- Docker image built successfully
- Security scan completed
- Application deployed from cloud instance

---

# 🔮 Future Enhancements

- Infrastructure as Code (Terraform)
- Auto-scaling build agents
- Container orchestration (Kubernetes)
- High-availability Jenkins setup
- Artifact registry integration
"""