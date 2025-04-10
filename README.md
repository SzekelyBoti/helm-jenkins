<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/your_username/helm-jenkins-pipeline">
  </a>

<h3 align="center">Helm-Jenkins CI/CD Pipeline for Kubernetes Monitoring</h3>
</br>
</br>
</br>
  <p align="center">
    Automated deployment and monitoring using Helm, Jenkins, Prometheus, and Grafana in a Kubernetes environment.
  </p>
  </br>
</br>
</div>

<!-- ABOUT THE PROJECT -->
## About The Project 📜

Helm-Jenkins is a containerized application deployment and monitoring solution that leverages Helm for Kubernetes orchestration, Jenkins for CI/CD automation, and Prometheus & Grafana for metrics collection and visualization. The project automates the deployment process, allowing for seamless integration and continuous delivery of applications with full monitoring capabilities.

The application can be deployed using the following methods:
1. **Simple Deployment** using `startup.sh`
2. **Helm Deployment** with `helm-startup.sh`
3. **Automated Jenkins Deployment** through a Jenkins pipeline
4. **GitLab CI/CD Deployment** using `.gitlab-ci.yml`

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With 🛠️

* [![Docker][Docker.com]][Docker-url]
* [![Kubernetes][Kubernetes-shield]][Kubernetes-url]
* [![Helm][Helm-shield]][Helm-url]
* [![Prometheus][Prometheus-shield]][Prometheus-url]
* [![Grafana][Grafana-shield]][Grafana-url]
* [![Jenkins][Jenkins-shield]][Jenkins-url]
* [![GitLab][GitLab-shield]][GitLab-url]
* [![Terraform][Terraform-shield]][Terraform-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- DEPLOYMENT METHODS -->
## Deployment Methods 🔧

### 1. Simple Deployment (`startup.sh`) 🚀
Run the script to deploy the application manually:
```sh
chmod +x startup.sh
./startup.sh
```
This script applies the necessary Kubernetes configurations.

### 2. Helm Deployment (helm-startup.sh) 🚀
Deploy the application using Helm:

```sh
chmod +x helm-startup.sh
./helm-startup.sh
```
This method installs Prometheus, Grafana, and the Tweet application via Helm charts.

### 3. Jenkins Deployment 🔧
Set up Jenkins and configure a Multibranch Pipeline with the Jenkinsfile. This automates deployment whenever changes are pushed.

### 4. GitLab Deployment 🌐
Use the .gitlab-ci.yml file to automate deployment in GitLab CI/CD. Ensure the necessary runner and credentials are configured.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Monitoring with Prometheus & Grafana 📊

### 1. Check Services 🔍
```sh
kubectl get services -n monitoring
```
### 2. Access Grafana, Prometheus, Nginx 🖥️

```sh
minikube service nginx -n monitoring
minikube service grafana -n monitoring
minikube service prometheus -n monitoring
```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact 📬

Szekely Botond  [![LinkedIn][linkedin-shield]][linkedin-url]  [![Email][email-shield]](mailto:szekelyboti1@gmail.com)  
Project Link: [![Project Link][project-link-shield]](https://github.com/boti95/helm-jenkins)

<p align="right">(<a href="#readme-top">back to top</a>)</p> <!-- MARKDOWN LINKS & IMAGES -->

[Docker.com]: https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white  
[Docker-url]: https://www.docker.com/
[Kubernetes-shield]: https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white  
[Kubernetes-url]: https://kubernetes.io/
[Helm-shield]: https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=helm&logoColor=white  
[Helm-url]: https://helm.sh/
[Prometheus-shield]: https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white  
[Prometheus-url]: https://prometheus.io/
[Grafana-shield]: https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white  
[Grafana-url]: https://grafana.com/
[Jenkins-shield]: https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white  
[Jenkins-url]: https://www.jenkins.io/
[GitLab-shield]: https://img.shields.io/badge/GitLab-FCA121?style=for-the-badge&logo=gitlab&logoColor=white  
[GitLab-url]: https://about.gitlab.com/
[Terraform-shield]: https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white  
[Terraform-url]: https://www.terraform.io/
[linkedin-shield]: https://img.shields.io/badge/LinkedIn-blue?style=for-the-badge&logo=linkedin&logoColor=white
[linkedin-url]: https://www.linkedin.com/in/boti-szekely
[email-shield]: https://img.shields.io/badge/Email-000000?style=for-the-badge&logo=gmail&logoColor=white
[project-link-shield]: https://img.shields.io/badge/Project%20Link-000000?style=for-the-badge&logo=github&logoColor=white
