module "vpc" {
  source  = "spacelift.io/vasn/vpc/aws"
  version = "0.1.0"

  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source  = "spacelift.io/vasn/subnet/aws"
  version = "0.1.2"

  subnets = var.subnets
  vpc_id  = module.vpc.vpc_id
}

module "gateway" {
  source  = "spacelift.io/vasn/gateway/aws"
  version = "0.1.0"

  vpc_id                          = module.vpc.vpc_id
  nat_gateway_public_subnet_1a_id = module.subnet.public_subnet_ids["public-subnet-1a"].subnet_id
  nat_gateway_public_subnet_1b_id = module.subnet.public_subnet_ids["public-subnet-1b"].subnet_id
}

module "route_table" {
  source  = "spacelift.io/vasn/route_table/aws"
  version = "0.1.0"

  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.gateway.internet_gateway_id
  nat_gateways_ids = {
    "nat_a" = module.gateway.nat_gateway_a_id,
    "nat_b" = module.gateway.nat_gateway_b_id
  }
  public_subnets  = module.subnet.public_subnet_ids
  private_subnets = module.subnet.private_subnet_ids
  data_subnets    = module.subnet.data_subnet_ids
}

module "security_group" {
  source  = "spacelift.io/vasn/security_group/aws"
  version = "0.1.0"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  web_port     = var.web_port
  app_port     = var.app_port
}

module "ecr" {
  source  = "spacelift.io/vasn/ecr/aws"
  version = "0.1.0"

  ecrs         = var.ecrs
  project_name = var.project_name
}

module "rds" {
  source  = "spacelift.io/vasn/rds/aws"
  version = "0.1.0"

  # Required inputs 
  db_allocated_storage = var.db_allocated_storage
  db_engine_type       = var.db_engine_type
  db_engine_version    = var.db_engine_version
  db_instance_class    = var.db_instance_class
  db_name              = var.db_name
  db_password          = var.db_password
  db_sg_ids = [
    module.security_group.db_security_group_id
  ]
  db_subnets = [
    module.subnet.data_subnet_ids["data-subnet-1a"].subnet_id,
    module.subnet.data_subnet_ids["data-subnet-1b"].subnet_id
  ]
  db_username     = var.db_username
  project_name    = var.project_name
  db_storage_type = var.db_storage_type
}

module "alb" {
  source  = "spacelift.io/vasn/alb/aws"
  version = "0.1.3"

  alb_security_groups = [
    module.security_group.alb_security_group_id
  ]
  alb_subnets = [
    module.subnet.public_subnet_ids["public-subnet-1a"].subnet_id,
    module.subnet.public_subnet_ids["public-subnet-1b"].subnet_id
  ]
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "secrets_manager" {
  source  = "spacelift.io/vasn/secrets_manager/aws"
  version = "0.1.0"

  project_name = var.project_name
  secret_map = merge(
    var.secret_map,
    {
      REACT_APP_API_URL       = "https://backend.${module.alb.alb_dns}"
      DATABASE_URL            = module.rds.db_connection_string
      AUTH_AD_REDIRECT_DOMAIN = "https://backend.${module.alb.alb_dns}"
      FRONT_END_HOST          = "https://frontend.${module.alb.alb_dns}"
    }
  )
}

module "ecs" {
  source  = "spacelift.io/vasn/ecs/aws"
  version = "0.1.0"

  app_port = var.app_port
  app_security_groups = [
    module.security_group.ecs_app_security_group_id
  ]
  app_subnets = [
    module.subnet.private_subnet_ids["app-subnet-1a"].subnet_id,
    module.subnet.private_subnet_ids["app-subnet-1b"].subnet_id
  ]
  app_target_group_arn          = module.alb.app_target_group_arn
  aws_secretsmanager_secret_arn = module.secrets_manager.aws_secretsmanager_secret_arn
  ecr_repo_url                  = module.ecr.ecr_repo_url
  ecs_task_app_main_cpu         = var.ecs_task_app_main_cpu
  ecs_task_app_main_memory      = var.ecs_task_app_main_memory
  ecs_task_app_overall_cpu      = var.ecs_task_app_overall_cpu
  ecs_task_app_overall_memory   = var.ecs_task_app_overall_memory
  ecs_task_web_main_cpu         = var.ecs_task_web_main_cpu
  ecs_task_web_main_memory      = var.ecs_task_web_main_memory
  ecs_task_web_overall_cpu      = var.ecs_task_web_overall_cpu
  ecs_task_web_overall_memory   = var.ecs_task_web_overall_memory
  project_name                  = var.project_name
  web_port                      = var.web_port
  web_security_groups = [
    module.security_group.ecs_web_security_group_id
  ]
  web_subnets = [
    module.subnet.private_subnet_ids["web-subnet-1a"].subnet_id
  ]
  web_target_group_arn = module.alb.web_target_group_arn
}