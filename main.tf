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

module "alb" {
  source  = "spacelift.io/vasn/alb/aws"
  version = "0.1.0"

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