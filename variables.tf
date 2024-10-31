
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

variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    name                    = string
    tier                    = string
    map_public_ip_on_launch = bool
  }))
}