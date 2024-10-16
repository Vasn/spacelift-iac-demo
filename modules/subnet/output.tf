output "subnet_ids" {
  value       = { for subnet_name, subnet in aws_subnet.main : subnet_name => subnet.id }
  description = "Map of subnet keys to their subnet IDs."
}

output "subnet_cidr_blocks" {
  value       = { for subnet_name, subnet in aws_subnet.main : subnet_name => subnet.cidr_block }
  description = "Map of subnet keys to their subnet CIDR blocks."
}