# Infrastructure as Code (IaC) for AWS

This repository contains the Terraform code for provisioning AWS infrastructure in modules. It supports a web application architecture consisting of a frontend, backend, and database.

## Introduction

This exercise aims to create a 3-tier web application infrastructure (presentation, application, and data) using ECS Fargate and RDS Postgres.

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

## Terraform Module Components

| Name               | Source              |
|--------------------|---------------------|
| alb                | ./modules/alb       |
| ecr                | ./modules/ecr       |
| ecs                | ./modules/ecs       |
| gateway            | ./modules/gateway   |
| rds                | ./modules/rds       |
| route_table        | ./modules/route_table|
| secrets_manager    | ./modules/secrets_manager |
| security_group     | ./modules/security_group |
| subnet             | ./modules/subnet     |
| vpc                | ./modules/vpc       |

## Step-by-Step

### Create Docker Image (Dockerfile) for Frontend and Backend

1. In your frontend repository, create a Dockerfile for the frontend React.js service.

    ```docker
    # Base image
    FROM node:18-alpine
    
    # Set working directory and copy project files
    WORKDIR /app
    COPY . .
    
    # Install dependencies
    RUN yarn install
    ENV PATH /app/node_modules/.bin:$PATH
    
    # Change working directory
    WORKDIR /app/src
    
    # Create build directory and build app
    RUN npm run build
    
    # Start serving when container starts
    CMD ["npm", "run", "start"]
    
    # Expose port
    EXPOSE 3000
    ```

2. In your backend repository, create a Dockerfile for the backend Nest.js service.

    ```docker
    # Base image
    FROM node:18-alpine
    
    # Set working directory and copy project files
    WORKDIR /app
    COPY . .
    
    # Install dependencies
    RUN yarn install
    ENV PATH /app/node_modules/.bin:$PATH
    
    # Generate Prisma client and run build script
    RUN yarn run db:generate
    RUN npm run-script build
    
    # Start serving when container starts
    CMD ["yarn", "start"]
    
    # Expose port
    EXPOSE 8001
    ```

3. Docker Commands
    1. To build and run
        1. Build & tag image: `docker build -t <NAMESPACE>/<REPOSITORY> .`
        2. Run container: `docker run -p 8001:8001 -v "$(pwd)/src:/app/src" <NAMESPACE>/<REPOSITORY>`
            1. Network flag: `--network <NETWORK_NAME>`
    2. To set up local PostgreSQL container for testing
        1. Create network: `docker network create <NETWORK_NAME>`
        2. Pull postgres image: `docker pull postgres`
        3. Run postgres container: `docker run --name <CONTAINER_NAME> --network <NETWORK_NAME> -p 5432:5432 -e POSTGRES_PASSWORD=<PASSWORD> -e POSTGRES_DB=<DB_NAME> -d postgres`
        4. Restore database from dump file: `docker exec -i <CONTAINER_NAME> psql -U postgres -d <DB_NAME> < <PATH_TO_DUMP_FILE>.sql`
    3. Debugging/Others
        1. Connect to container shell: `docker exec -it <CONTAINER_ID> sh`
        2. List docker images: `docker images`
        3. List all containers: `docker ps -a`
        4. Remove images: `docker rmi <IMAGE_ID>`
        5. Remove containers: `docker rm <CONTAINER_ID>`

### Create GitHub Repository for Frontend and Backend

1. Follow the instructions on GitHub to set up a repository. 
2. If you have cloned from another repository, instead of adding the upstream origin, change the upstream origin instead with `git remote set-url origin https://github.com/your-username/your-new-repo.git`

### Create Your Terraform Modules

- Within your project directory, create the modules listed below to set up your Networking, Security Groups, Compute, Storage/Data, ALB/DNS, and Secrets Manager, each module with its own `main.tf`, `variables.tf`, and `output.tf` to store its resources, variables, and outputs respectively.

1. **VPC (Networking)**
    1. Define your VPC (Example)
    
    ```hcl
    # in "main.tf"
    resource "aws_vpc" "main" {
      cidr_block           = var.vpc_cidr_block
      instance_tenancy     = "default"
      enable_dns_hostnames = true
    
      tags = {
        Name = "main-vpc"
      }
    }
    
    # in "variables.tf"
    variable "vpc_cidr_block" {
      type = string
    }
    
    # in "output.tf"
    output "vpc_id" {
      value = aws_vpc.main.id
    }
    
    output "default_network_acl_id" {
      value = aws_vpc.main.default_network_acl_id
    }
    ```

2. **Subnet (Networking)**
    1. Define your subnet
    
    ```hcl
    resource "aws_subnet" "main" {
      for_each = var.subnets
    	
    	...
    }
    
    variable "subnets" {
    	type = map(object({
    		...
    	}))
    }
    ```

3. **Gateway (Networking)** - IGW & NAT Gateway
    1. Define your Internet Gateway.
    2. Define your Elastic IP for your NAT.
    3. Define your NAT gateway.

4. **Route Tables (Networking)**
    1. Define your Route Tables.
    2. Define your Route Table-Subnet associations.

5. **Security Group**
    1. Define your security groups (ECS, RDS & ALB).

6. **ECR (Compute)**
    1. Define your ECR repository.

7. **ECS (Compute)** - Includes IAM for ECS execution
    1. Define your ECS cluster & capacity providers.
    2. Define your Task Definitions (web & app).
        1. Optional: Define your CloudWatch Log Group for container logging.
    3. Define your ECS service (web & app).
    4. Define your IAM Role (Task execution role).
        1. With `AmazonECSTaskExecutionRolePolicy` & `SecretsManagerReadWrite` managed policy.

8. **RDS (Storage)** - PostgreSQL
    1. Define your Database Subnet Group.
    2. Define your Database Instance.

9. **ALB - ACM, DNS (Azure) & ALB**
    1. Define your (Application) Load Balancer.
    2. Define your Target Groups (web & app).
    3. Define your ACM Certificate & Certificate Validation.
    4. Define your Azure DNS CNAME Records (subdomains and CNAME Validation).
        1. e.g. [vasilis.example.com](http://vasilis.example.com) and [api.vasilis.example.com](http://api.vasilis.example.com).
    5. Define your Listeners (http & https).
    6. Define your Listener Rules (to target web and app via host-based routing).

10. **Secrets Manager**
    1. Define a Secrets Manager Secret and a Version with your secrets.

### How to Deploy the Terraform IaC?

1. Clone this repository.
2. Duplicate the file `config.tfvars-sample` and rename it to `config.tfvars` or `config-<environment>.tfvars` for your different environments. The file consists of variables which are required for you to be set and you can view their details in the respective `variables.tf` file.
3. Set up your AWS credentials via `aws configure --profile <profile-name>`.
4. Ensure that the `aws_profile_name` in your `config.tfvars` file is set to the above profile name.
5. Perform your Terraform workflow by running `terraform init`, `terraform plan`, and `terraform apply`.
    1. Note: For `terraform plan`, `terraform apply`, and `terraform destroy`, if you are using `.tfvars` file to assign values to your variables, you must run the commands with a `--var-file` flag.
    
    For example:
    
    ```bash
    terraform plan -var-file="config.tfvars"
    terraform apply -var-file="config.tfvars"
    terraform destroy -var-file="config.tfvars"
    ```

### Set Up GitHub Actions Workflow to Automate New Deployments to ECS (Fargate)

- **Flow**: Push to main → Triggers workflow → Configure AWS Credentials → Login to Amazon ECR → Build and tag image → Push to ECR → Trigger new deployment on ECS.

1. Configure AWS credentials in GitHub Repository Secrets (for each repo).
    1. Note: It is recommended to assume Role directly using GitHub OIDC provider instead.
    2. Create environment (e.g., production/dev/staging).
    3. Add the secrets required for your workflow.
        1. AWS_ACCESS_KEY_ID
        2. AWS_SECRET_ACCESS_KEY
        3. AWS_REGION
        4. ECR_REPOSITORY
        5. ECS_CLUSTER
        6. ECS_SERVICE
        7. ECS_TASK_DEFINITION
        8. CONTAINER_NAME

2. Create a workflow `.yml` or `.yaml` file in the “.github/workflows” folder (any filename, e.g., `aws.yml`).

3. **Example workflow**:

```yaml
name: Build and Deploy to AWS ECS
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
        
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}

      - name: Login to Amazon ECR
        id: ecr-login
        run: |
          aws ecr get-login-password --region ${{ secrets.AWS_REGION }} | docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com
        
      - name: Build the Docker image
        run: |
          docker build -t <ECR_REPOSITORY> .
          docker tag <ECR_REPOSITORY>:latest <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<ECR_REPOSITORY>:latest

      - name: Push the Docker image
        run: |
          docker push <ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/<ECR_REPOSITORY>:latest

      - name: Deploy to Amazon ECS
        run: |
          aws ecs update-service --cluster <ECS_CLUSTER> --service <ECS_SERVICE> --force-new-deployment
