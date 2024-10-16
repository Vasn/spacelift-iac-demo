variable "project_name" {
  type = string
}

### ENV Variables (Backend app) ###
variable "react_app_api_url" {
  type = string
}

variable "database_url" {
  type = string
}

variable "first_super_admin_email" {
  type = string
}

variable "first_super_admin_password" {
  type = string
}

variable "jwt_secret" {
  type = string
}

variable "auth_ad_tenant_id" {
  type = string
}

variable "auth_ad_client_id" {
  type = string
}

variable "auth_ad_client_secret" {
  type = string
}

variable "auth_ad_redirect_domain" {
  type = string
}

variable "auth_ad_cookie_key" {
  type = string
}

variable "auth_ad_cookie_iv" {
  type = string # 12 digit random value
}

variable "front_end_host" {
  type = string
}

variable "dd_env" {
  type = string
}

variable "dd_logs_injection" {
  type = bool
}

variable "github_token" {
  type = string
}