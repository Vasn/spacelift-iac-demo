variable "instances" {
  type = map(object({
    ami                    = string
    instance_type          = string
    subnet_id              = string
    key_name               = string
    user_data              = string
    vpc_security_group_ids = list(string)
    iam_instance_profile   = string
    name                   = string
  }))
}