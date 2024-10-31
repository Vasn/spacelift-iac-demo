module "vpc" {
  source  = "spacelift.io/vasn/vpc/aws"
  version = "0.1.0"

  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source  = "spacelift.io/vasn/subnet/aws"
  version = "0.1.0"

  subnets = var.subnets
  vpc_id  = module.vpc.vpc_id
}

module "gateway" {
  source  = "spacelift.io/vasn/gateway/aws"
  version = "0.1.0"

  vpc_id                          = module.vpc.vpc_id
  nat_gateway_public_subnet_1a_id = module.subnets.subnet_ids["public-subnet-1a"]
  nat_gateway_public_subnet_1b_id = module.subnets.subnet_ids["public-subnet-1b"]
}