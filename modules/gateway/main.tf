resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.vpc_id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_eip" "nat_a_eip" {
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_eip" "nat_b_eip" {
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.nat_a_eip.id
  subnet_id     = var.nat_gateway_public_subnet_1a_id

  tags = {
    Name = "nat-gateway-public-subnet-1a"
  }
}

resource "aws_nat_gateway" "nat_gateway_b" {
  allocation_id = aws_eip.nat_b_eip.id
  subnet_id     = var.nat_gateway_public_subnet_1b_id

  tags = {
    Name = "nat-gateway-public-subnet-1b"
  }
}