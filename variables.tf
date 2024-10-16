## Providers ##
variable "aws_profile_name" {
  type        = string
  description = "Name of profile configured using AWS CLI"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "project_name" {
  type        = string
  description = "Project Name"
}

variable "project_owner" {
  type        = string
  description = "Project Owner"
}

variable "azure_subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

## Modules ##
# VPC
variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR Block Range"
}

# Subnets
variable "subnets" {
  description = "Public, web, app and database subnets"
}

# RDS
variable "db_allocated_storage" {
  description = "The amount of allocated storage for the RDS instance (in GB)"
}

variable "db_name" {
  description = "Database Name"
}

variable "db_engine_type" {
  description = "Database Engine Type"
}

variable "db_engine_version" {
  description = "Database Engine Version (based on the DB type)"
}

variable "db_instance_class" {
  description = "RDS Instance Type e.g. db.t2.micro"
}

variable "db_username" {
  description = "Username for master user"
}

variable "db_password" {
  description = "Password for master user"
}

variable "db_storage_type" {
  description = "RDS Storage Type e.g. gp3"
}

# Azure DNS
variable "web_domain" {
  description = "Web (Frontend) Domain Name"
}

variable "app_domain" {
  description = "App (Backend) Domain Name"
}

variable "azure_dns_zone_name" {
  description = "Azure DNS Zone Name"
}

variable "azure_resource_group_name" {
  description = "Azure DNS Zone Resource Group Name"
}

variable "azure_cname_ttl" {
  description = "Azure CNAME Record Time To Live (TTL)"
}

# ALB
# variable "web_instance_port" {
#   description = "Instance Port for Web (Frontend)"
# }

# variable "app_instance_port" {
#   description = "Instance Port for App (Backend)"
# }

# ECR
variable "ecrs" {
  description = "Names of the container registry"
}

# ECS
variable "ecs_task_web_overall_cpu" {
  description = "Amount of combined CPU resources allocated to all containers in a web task"
}

variable "ecs_task_web_overall_memory" {
  description = "Amount of combined memory resources allocated to all containers in a web task"
}

variable "ecs_task_web_main_cpu" {
  description = "Amount of CPU resources allocated a web container"
}

variable "ecs_task_web_main_memory" {
  description = "Amount of memory resources allocated a web container"
}

variable "web_port" {
  description = "Container port for web container"
}

variable "ecs_task_app_overall_cpu" {
  description = "Amount of combined CPU resources allocated to all containers in a app task"
}

variable "ecs_task_app_overall_memory" {
  description = "Amount of combined memory resources allocated to all containers in a app task"
}

variable "ecs_task_app_main_cpu" {
  description = "Amount of CPU resources allocated a app container"
}

variable "ecs_task_app_main_memory" {
  description = "Amount of memory resources allocated a app container"
}

variable "app_port" {
  description = "Container port for app container"
}



## App Backend ENV Variables ##
# variable "react_app_api_url" {}
# variable "database_url" {}
variable "first_super_admin_email" {}
variable "first_super_admin_password" {}
variable "jwt_secret" {}
variable "auth_ad_tenant_id" {}
variable "auth_ad_client_id" {}
variable "auth_ad_client_secret" {}
# variable "auth_ad_redirect_domain" {}
variable "auth_ad_cookie_key" {}
variable "auth_ad_cookie_iv" {}
# variable "front_end_host" {}
variable "dd_env" {}
variable "dd_logs_injection" {}
variable "github_token" {}