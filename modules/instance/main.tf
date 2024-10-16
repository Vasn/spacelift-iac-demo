resource "aws_instance" "instance" {
  for_each = var.instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  key_name               = each.value.key_name
  vpc_security_group_ids = each.value.vpc_security_group_ids
  iam_instance_profile   = each.value.iam_instance_profile
  user_data              = each.value.user_data

  tags = {
    Name = each.value.name
  }
}