output "instance_arn" {
  value       = { for key, instance in aws_instance.instance : key => instance.arn }
  description = "Map of instance keys to their arn."
}

output "instance_id" {
  value       = { for key, instance in aws_instance.instance : key => instance.id }
  description = "Map of instance keys to their id."
}

output "instance_public_ip" {
  value       = { for key, instance in aws_instance.instance : key => instance.public_ip }
  description = "Map of instance keys to their public IP."
}

output "instance_private_dns" {
  value       = { for key, instance in aws_instance.instance : key => instance.private_dns }
  description = "Map of instance keys to their private dns."
}

output "instance_public_dns" {
  value       = { for key, instance in aws_instance.instance : key => instance.public_dns }
  description = "Map of instance keys to their public dns."
}