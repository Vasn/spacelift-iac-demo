### Overview of main.tf ###

## Networking
# - VPC
# - Subnets
# - Internet Gateway (IGW)
# - Network Address Translation (NAT) Gateway
# - Route Tables

## Security
# - Security Groups

## Compute
# - EC2 Instances

## Storage
# - RDS (PostgreSQL)

## ALB & DNS records
# - ACM
# - DNS
# - ALB

## Secrets Manager
# - Secret Version


### Modules ###
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr_block
}

module "subnets" {
  source = "./modules/subnet"

  subnets = var.subnets
  vpc_id  = module.vpc.vpc_id
}

module "gateway" {
  source = "./modules/gateway"

  vpc_id                          = module.vpc.vpc_id
  nat_gateway_public_subnet_1a_id = module.subnets.subnet_ids["public-subnet-1a"]
  nat_gateway_public_subnet_1b_id = module.subnets.subnet_ids["public-subnet-1b"]
}

module "route_table" {
  source = "./modules/route_table"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.gateway.internet_gateway_id
  nat_gateway_a_id    = module.gateway.nat_gateway_a_id
  nat_gateway_b_id    = module.gateway.nat_gateway_b_id
  public_subnet_1a_id = module.subnets.subnet_ids["public-subnet-1a"]
  public_subnet_1b_id = module.subnets.subnet_ids["public-subnet-1b"]
  web_subnet_1a_id    = module.subnets.subnet_ids["web-subnet-1a"]
  app_subnet_1a_id    = module.subnets.subnet_ids["app-subnet-1a"]
  app_subnet_1b_id    = module.subnets.subnet_ids["app-subnet-1b"]
  data_subnet_1a_id   = module.subnets.subnet_ids["data-subnet-1a"]
  data_subnet_1b_id   = module.subnets.subnet_ids["data-subnet-1b"]
}

module "security_group" {
  source = "./modules/security_group"

  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  vpc_cidr_block = var.vpc_cidr_block
  web_port       = var.web_port
  app_port       = var.app_port
}

module "iam" {
  source = "./modules/iam"
}

# module "instances" {
#   source = "./modules/instance"

#   instances = {
#     "bastion-1a" = {
#       ami                    = "ami-0aa097a5c0d31430a" # ap-southeast-1 linux 2023
#       instance_type          = "t2.micro"
#       subnet_id              = module.subnets.subnet_ids["public-subnet-1a"]
#       key_name               = "bastionkey"
#       user_data              = ""
#       vpc_security_group_ids = [module.security_group.bastion_security_group_id]
#       iam_instance_profile   = ""
#       name                   = "bastion-instance-public"
#     },
#     "web-1a" = {
#       ami                    = "ami-0aa097a5c0d31430a"
#       instance_type          = "t2.medium"
#       subnet_id              = module.subnets.subnet_ids["web-subnet-1a"]
#       key_name               = "webserverkeypair"
#       user_data              = templatefile("./scripts/web.sh", { "aws_secretsmanager_secret_id" = module.secrets_manager.aws_secretsmanager_secret_name })
#       vpc_security_group_ids = [module.security_group.web_security_group_id]
#       iam_instance_profile   = module.iam.ec2_profile.name
#       name                   = "web-instance-private"
#     },
#     "app-1a" = {
#       ami                    = "ami-0aa097a5c0d31430a"
#       instance_type          = "t2.medium"
#       subnet_id              = module.subnets.subnet_ids["app-subnet-1a"]
#       key_name               = "webserverkeypair"
#       user_data              = base64encode(templatefile("./scripts/app.sh", { "aws_secretsmanager_secret_id" = module.secrets_manager.aws_secretsmanager_secret_name }))
#       vpc_security_group_ids = [module.security_group.app_security_group_id]
#       iam_instance_profile   = module.iam.ec2_profile.name
#       name                   = "app-instance-private-1a"
#     },
#     "app-1b" = {
#       ami                    = "ami-0aa097a5c0d31430a"
#       instance_type          = "t2.medium"
#       subnet_id              = module.subnets.subnet_ids["app-subnet-1b"]
#       key_name               = "webserverkeypair"
#       user_data              = base64encode(templatefile("./scripts/app.sh", { "aws_secretsmanager_secret_id" = module.secrets_manager.aws_secretsmanager_secret_name }))
#       vpc_security_group_ids = [module.security_group.app_security_group_id]
#       iam_instance_profile   = module.iam.ec2_profile.name
#       name                   = "app-instance-private-1b"
#     }
#   }
#   depends_on = [module.secrets_manager.app_env_var_resource]
# }

module "rds" {
  source = "./modules/rds"

  project_name         = var.project_name
  db_allocated_storage = var.db_allocated_storage
  db_name              = var.db_name
  db_engine_type       = var.db_engine_type
  db_engine_version    = var.db_engine_version
  db_instance_class    = var.db_instance_class
  db_username          = var.db_username
  db_password          = var.db_password
  db_storage_type      = var.db_storage_type
  db_sg_ids = [
    module.security_group.db_security_group_id
  ]
  db_subnets = [
    module.subnets.subnet_ids["data-subnet-1a"],
    module.subnets.subnet_ids["data-subnet-1b"]
  ]
}

module "alb" {
  source = "./modules/alb"

  project_name = var.project_name
  alb_security_groups = [
    module.security_group.alb_security_group_id
  ]
  alb_subnets = [
    module.subnets.subnet_ids["public-subnet-1a"],
    module.subnets.subnet_ids["public-subnet-1b"]
  ]
  vpc_id = module.vpc.vpc_id
  # web_instance_ids = {
  #   "web-1a" = module.instances.instance_id["web-1a"]
  # }
  web_instance_port = var.web_port
  # app_instance_ids = {
  #   "app-1a" = module.instances.instance_id["app-1a"],
  #   "app-1b" = module.instances.instance_id["app-1b"]
  # }
  app_instance_port         = var.app_port
  web_domain                = var.web_domain
  app_domain                = var.app_domain
  azure_dns_zone_name       = var.azure_dns_zone_name
  azure_resource_group_name = var.azure_resource_group_name
  azure_cname_ttl           = var.azure_cname_ttl
}

module "secrets_manager" {
  source = "./modules/secrets_manager"

  project_name               = var.project_name
  react_app_api_url          = "https://${var.app_domain}"
  database_url               = module.rds.db_connection_string
  first_super_admin_email    = var.first_super_admin_email
  first_super_admin_password = var.first_super_admin_password
  jwt_secret                 = var.jwt_secret
  auth_ad_tenant_id          = var.auth_ad_tenant_id
  auth_ad_client_id          = var.auth_ad_client_id
  auth_ad_client_secret      = var.auth_ad_client_secret
  auth_ad_redirect_domain    = "https://${var.app_domain}"
  auth_ad_cookie_key         = var.auth_ad_cookie_key
  auth_ad_cookie_iv          = var.auth_ad_cookie_iv
  front_end_host             = "https://${var.web_domain}"
  dd_env                     = var.dd_env
  dd_logs_injection          = var.dd_logs_injection
  github_token               = var.github_token
}

module "ecr" {
  source = "./modules/ecr"

  ecrs         = var.ecrs
  project_name = var.project_name
}

module "ecs" {
  source = "./modules/ecs"

  project_name                  = var.project_name
  ecs_task_web_overall_cpu      = var.ecs_task_web_overall_cpu
  ecs_task_web_overall_memory   = var.ecs_task_web_overall_memory
  ecr_repo_url                  = module.ecr.ecr_repo_url
  ecs_task_web_main_cpu         = var.ecs_task_web_main_cpu
  ecs_task_web_main_memory      = var.ecs_task_web_main_memory
  web_port                      = var.web_port
  ecs_task_app_overall_cpu      = var.ecs_task_app_overall_cpu
  ecs_task_app_overall_memory   = var.ecs_task_app_overall_memory
  ecs_task_app_main_cpu         = var.ecs_task_app_main_cpu
  ecs_task_app_main_memory      = var.ecs_task_app_main_memory
  app_port                      = var.app_port
  aws_secretsmanager_secret_arn = module.secrets_manager.aws_secretsmanager_secret_arn
  web_subnets                   = [module.subnets.subnet_ids["web-subnet-1a"]]
  web_security_groups           = [module.security_group.ecs_web_security_group_id]
  web_target_group_arn          = module.alb.web_target_group_arn
  app_subnets                   = [module.subnets.subnet_ids["app-subnet-1a"], module.subnets.subnet_ids["app-subnet-1b"]]
  app_security_groups           = [module.security_group.ecs_app_security_group_id]
  app_target_group_arn          = module.alb.app_target_group_arn
}

# work on the security group > alb > target_group 

# terraform plan -var-file="config.tfvars" 
# terraform apply -var-file="config.tfvars" --auto-approve
# terraform destroy -var-file="config.tfvars"