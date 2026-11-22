# Terraform AWS EC2 - Static Website Deployment

A hands-on DevOps lab to automate the deployment of a static Quiz Game website on AWS EC2 using Terraform.

## Technologies

- Terraform (Infrastructure as Code)
- AWS EC2 & Security Groups
- Bash / EC2 User Data
- Nginx
- GitHub

## Architecture

Terraform runs on a control EC2 instance using an IAM Role to provision a web server EC2 instance and a Security Group.

The web server automatically installs Nginx, downloads the Quiz Game source code from GitHub, and serves the static website over HTTP.

## What I Practiced

- Provisioning AWS infrastructure with Terraform
- Configuring EC2 and Security Groups
- Automating server setup using EC2 User Data
- Deploying a static website with Nginx
- Managing infrastructure with `terraform init`, `plan`, `apply`, and `destroy`

---

**Course:** DevOps DO2606  
**Completed:** October 20, 2026