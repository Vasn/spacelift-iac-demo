variable "project_name" {
  type = string
}

variable "db_allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
}

variable "db_engine_type" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_storage_type" {
  type    = string
  default = "gp2"
}

variable "db_sg_ids" {
  type = list(string)
}

variable "db_subnets" {
  type = list(string)
}