variable "project_name" {}
variable "ecs_task_web_overall_cpu" {}
variable "ecs_task_web_overall_memory" {}
variable "ecr_repo_url" {}
variable "ecs_task_web_main_cpu" {}
variable "ecs_task_web_main_memory" {}
variable "web_port" {}
variable "ecs_task_app_overall_cpu" {}
variable "ecs_task_app_overall_memory" {}
variable "ecs_task_app_main_cpu" {}
variable "ecs_task_app_main_memory" {}
variable "app_port" {}
variable "aws_secretsmanager_secret_arn" {}

variable "web_subnets" {
  type = list(string)
}

variable "web_security_groups" {
  type = list(string)
}

variable "web_target_group_arn" {}

variable "app_subnets" {
  type = list(string)
}

variable "app_security_groups" {
  type = list(string)
}

variable "app_target_group_arn" {}