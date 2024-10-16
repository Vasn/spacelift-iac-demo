output "internet_gateway_id" {
  value = aws_internet_gateway.internet_gateway.id
}

output "nat_gateway_a_id" {
  value = aws_nat_gateway.nat_gateway_a.id
}

output "nat_gateway_b_id" {
  value = aws_nat_gateway.nat_gateway_b.id
}