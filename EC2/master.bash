#!/bin/bash

# Update system
dnf update -y

# Install Java (Jenkins requirement)
dnf install -y java-17-amazon-corretto

# Add Jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
dnf install -y jenkins

# Install Git
dnf install -y git

# Install Docker
dnf install -y docker

# Start and enable services
systemctl enable jenkins
systemctl start jenkins

systemctl enable docker
systemctl start docker

# Add jenkins user to docker group
usermod -aG docker jenkins

# Restart Jenkins to apply docker group change
systemctl restart jenkins
