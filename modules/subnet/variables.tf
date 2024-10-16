variable "vpc_id" {}

variable "subnets" {
  type = map(object({
    cidr_block              = string
    availability_zone       = string
    name                    = string
    tier                    = string
    map_public_ip_on_launch = bool
  }))
}