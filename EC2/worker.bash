#!/bin/bash

# Update system
dnf update -y

# Install Java (required for Jenkins agent)
dnf install -y java-17-amazon-corretto

# Install Git
dnf install -y git

# Install Docker
dnf install -y docker

# Start Docker
systemctl enable docker
systemctl start docker

# Create Jenkins user
useradd -m -s /bin/bash jenkins

# Add jenkins user to docker group
usermod -aG docker jenkins

# Set permissions
chmod 777 /var/run/docker.sock
