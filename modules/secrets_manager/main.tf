resource "aws_secretsmanager_secret" "main" {
  name                    = "${var.project_name}-app-env-variables-${random_integer.number.result}"
  recovery_window_in_days = 0 # force deletion without recovery
  description             = "Environment variables for ${var.project_name}"
}

resource "random_integer" "number" {
  min = 1
  max = 100
}

resource "aws_secretsmanager_secret_version" "app_env_var" {
  secret_id = aws_secretsmanager_secret.main.id
  secret_string = jsonencode({
    REACT_APP_API_URL          = var.react_app_api_url
    DATABASE_URL               = var.database_url
    FIRST_SUPER_ADMIN_EMAIL    = var.first_super_admin_email
    FIRST_SUPER_ADMIN_PASSWORD = var.first_super_admin_password
    JWT_SECRET                 = var.jwt_secret
    AUTH_AD_TENANT_ID          = var.auth_ad_tenant_id
    AUTH_AD_CLIENT_ID          = var.auth_ad_client_id
    AUTH_AD_CLIENT_SECRET      = var.auth_ad_client_secret
    AUTH_AD_REDIRECT_DOMAIN    = var.auth_ad_redirect_domain
    AUTH_AD_COOKIE_KEY         = var.auth_ad_cookie_key
    AUTH_AD_COOKIE_IV          = var.auth_ad_cookie_iv
    FRONT_END_HOST             = var.front_end_host
    DD_ENV                     = var.dd_env
    DD_LOGS_INJECTION          = var.dd_logs_injection
    GITHUB_TOKEN               = var.github_token
  })
}