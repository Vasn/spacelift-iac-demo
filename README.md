# Infrastructure as Code (IaC) for AWS

This repository contains the Terraform code for provisioning AWS infrastructure in modules. It supports a web application architecture consisting of a frontend, backend, and database.

## Overview

### Networking
- **VPC**: Virtual Private Cloud for isolation.
- **Subnets**: Public and private subnets for routing traffic.
- **Internet Gateway (IGW)**: To allow internet access for the public subnets.
- **Network Address Translation (NAT) Gateway**: To enable internet access for instances in private subnets.
- **Route Tables**: Custom routing tables for managing traffic flow.

### Security
- **Security Groups**: Define inbound and outbound rules for controlling access to resources.

### Compute
- **ECR (Elastic Container Registry)**: Stores Docker images for the application.
- **ECS (Elastic Container Service)**: Manages containerized workloads.

### Storage
- **RDS (Relational Database Service)**: PostgreSQL database for persistent storage.

### ALB & DNS Records
- **ACM (AWS Certificate Manager)**: Manages SSL/TLS certificates.
- **DNS (Azure)**: Configures DNS records for the application.
- **ALB (Application Load Balancer)**: Distributes traffic across the application.

### Secrets Management
- **Secrets Manager**: Securely stores and manages sensitive information such as API keys and passwords.

## Usage

1. Clone the repository.
2. Duplicate the "config.tfvars-sample" and remove the postfix "-sample"
2. Modify the variables and settings according to your infrastructure requirements.
3. Run `terraform init` to initialize the Terraform environment.
4. Use `terraform apply` to provision the infrastructure on AWS.
