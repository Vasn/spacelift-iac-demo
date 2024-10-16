
# Create ec2 role and policy to allow ec2 to get secrets
resource "aws_iam_role" "ec2_role" {
  name = "EC2SecretsManagerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "get_secret" {
  name        = "GetSecretsPolicy"
  description = "Policy to get secrets from secrets manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_secrets_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.get_secret.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2Profile"
  role = aws_iam_role.ec2_role.name
}