output "db_hostname" {
  value = aws_db_instance.main.address
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_connection_string" {
  value = "postgres://${aws_db_instance.main.username}:${aws_db_instance.main.password}@${aws_db_instance.main.endpoint}/${aws_db_instance.main.db_name}?schema=public"
}