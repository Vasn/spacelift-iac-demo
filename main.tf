# providers
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.73.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region

  default_tags {
    tags = {
      app_name = "${var.project_name}-app"
      owner    = var.project_owner
    }
  }
}

# resources/modules
module "vpc" {
  source = "spacelift.io/vasn/vpc/aws"
  version = "0.1.0"

  aws_region = var.aws_region
  vpc_cidr_block = var.vpc_cidr_block
}

# variables
variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "project_owner" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}