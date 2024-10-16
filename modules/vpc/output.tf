output "vpc_id" {
  value = aws_vpc.main.id
}

output "default_network_acl_id" {
  value = aws_vpc.main.default_network_acl_id
}