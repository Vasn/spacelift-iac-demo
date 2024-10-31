# providers
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      app_name = "${var.project_name}-app"
      owner    = var.project_owner
    }
  }
}

# resources/modules
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
