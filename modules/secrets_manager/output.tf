output "aws_secretsmanager_secret_arn" {
  value = aws_secretsmanager_secret.main.arn
}

output "aws_secretsmanager_secret_name" {
  value = aws_secretsmanager_secret.main.name
}

output "app_env_var_resource" {
  value = aws_secretsmanager_secret_version.app_env_var
}
