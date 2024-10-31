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