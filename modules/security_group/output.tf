output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_web_security_group_id" {
  value = aws_security_group.ecs_web_sg.id
}

output "ecs_app_security_group_id" {
  value = aws_security_group.ecs_app_sg.id
}

output "db_security_group_id" {
  value = aws_security_group.db_sg.id
}