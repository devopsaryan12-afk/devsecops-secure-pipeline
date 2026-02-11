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

#### Expected output
{
    "message": "DevSecOps Pipeline Running",
    "hostname": "LAPTOP-HFD3BCDR",
    "timestamp": "2026-02-11T17:15:42.335Z"
}