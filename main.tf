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
  nat_gateway_public_subnet_1a_id = module.subnet.subnet_ids["public-subnet-1a"]
  nat_gateway_public_subnet_1b_id = module.subnet.subnet_ids["public-subnet-1b"]
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
  private_subnets = {
    for key, value in module.subnet.subnet_ids :
    key => {
      subnet_id = value
    }
    if substr(key, 0, 3) == "web" || substr(key, 0, 3) == "app"
  }
  public_subnets = {
    for key, value in module.subnet.subnet_ids :
    key => {
      subnet_id       = value
      route_table_key = (substr(key, length(key) - 1, 1)) == "a" ? "nat_a" : "nat_b"
    }
    if substr(key, 0, 6) == "public"
  }
  data_subnets = {
    for key, value in module.subnet.subnet_ids :
    key => {
      subnet_id = value
    }
    if substr(key, 0, 4) == "data"
  }
}