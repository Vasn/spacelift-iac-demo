module "vpc" {
  source  = "spacelift.io/vasn/vpc/aws"
  version = "0.1.0"

  vpc_cidr_block = var.vpc_cidr_block
}

module "subnet" {
  source  = "spacelift.io/vasn/subnet/aws"
  version = "0.1.1"

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