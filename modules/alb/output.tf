output "web_target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "app_target_group_arn" {
  value = aws_lb_target_group.app.arn
}

output "alb_dns" {
  value = aws_lb.main.dns_name
}