# Tinker Tailor Docker Spy

## Overview
Tinker Tailor Docker Spy is a containerized application deployed using Kubernetes, monitored with Prometheus and Grafana, and automated via Jenkins. 
It leverages Helm for deployment and follows a CI/CD approach to ensure efficient application delivery and monitoring.

All deployment methods achieve the same outcome, but the process differs:
1. **Deployment** using `startup.sh`
2. **Helm Deployment** using `helm-startup.sh`
3. **Jenkins Deployment** via a Jenkins pipeline
4. **GitLab Deployment** using `.gitlab-ci.yml`

**Note:** Some IP/port changes may be necessary based on your setup.

## Features
- Dockerized frontend and backend
- Kubernetes deployment using Minikube
- Helm-based deployment configuration
- Prometheus for metrics collection
- Grafana for visualization
- Automated CI/CD pipeline with Jenkins and GitLab

## Prerequisites
Ensure you have the following installed:
- Docker & Docker Compose
- Kubernetes (Minikube)
- Helm
- Prometheus & Grafana
- Jenkins (for CI/CD automation)
- GitLab (if using self-hosted GitLab for CI/CD)

## Deployment Methods
### 1. Simple Deployment (`startup.sh`)
Run the script to deploy the application manually:
```sh
chmod +x startup.sh
./startup.sh
```
This script applies the necessary Kubernetes configurations.

### 2. Helm Deployment (`helm-startup.sh`)
Deploy the application using Helm:
```sh
chmod +x helm-startup.sh
./helm-startup.sh
```
This method installs Prometheus, Grafana, and the Tweet application via Helm charts.

### 3. Jenkins Deployment
Set up Jenkins and configure a Multibranch Pipeline with the `Jenkinsfile`. This automates deployment whenever changes are pushed.

### 4. GitLab Deployment
Use the `.gitlab-ci.yml` file to automate deployment in GitLab CI/CD. Ensure the necessary runner and credentials are configured.

## Monitoring with Prometheus & Grafana
### 1. Check Services
```sh
kubectl get services -n monitoring
```

### 2. Access Grafana,prometheus,nginx
```sh
minikube service nginx -n monitoring
minikube service grafana -n monitoring
minikube service prometheus -n monitoring
```

