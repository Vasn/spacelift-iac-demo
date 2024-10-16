variable "project_name" {
  type = string
}

variable "alb_security_groups" {
  type = list(string)
}

variable "alb_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

# variable "web_instance_ids" {
#   type = map(string)
# }

variable "web_instance_port" {
  type = number # port 3000 
}

# variable "app_instance_ids" {
#   type = map(string)
# }

variable "app_instance_port" {
  type = number # port 8001
}

variable "web_domain" {
  type = string # "vasilis.swiftoffice.org"
}

variable "app_domain" {
  type = string # "api.vasilis.swiftoffice.org"
}

variable "azure_dns_zone_name" {
  type = string # "swiftoffice.org"
}

variable "azure_resource_group_name" {
  type = string # "network-rg"
}

variable "azure_cname_ttl" {
  type    = number
  default = 300 # low because it is just a short term project, default 3600s/1h
}