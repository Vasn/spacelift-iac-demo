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

variable "web_port" {
  type        = number
  description = "Container port for web container"
}

variable "app_port" {
  type        = number
  description = "Container port for app container"
}

variable "ecrs" {
  type        = map(string)
  description = "Names of the container registry"
}

variable "db_allocated_storage" {
  type        = number
  description = "The amount of allocated storage for the RDS instance (in GB)"
}

variable "db_name" {
  type        = string
  description = "Database Name"
}

variable "db_engine_type" {
  type        = string
  description = "Database Engine Type"
}

variable "db_engine_version" {
  type        = string
  description = "Database Engine Version (based on the DB type)"
}

variable "db_instance_class" {
  type        = string
  description = "RDS Instance Type e.g. db.t2.micro"
}

variable "db_username" {
  type        = string
  description = "Username for master user"
}

variable "db_password" {
  type        = string
  description = "Password for master user"
}

variable "db_storage_type" {
  type        = string
  description = "RDS Storage Type e.g. gp3"
}

variable "secret_map" {
  type        = map(string)
  description = "Map of key-pair secrets"
}