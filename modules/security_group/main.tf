resource "aws_security_group" "ecs_web_sg" {
  name        = "${var.project_name}-ecs-web-sg"
  description = "Allow inbound from ALB to web container"
  vpc_id      = var.vpc_id

  ingress {
    security_groups = [aws_security_group.alb_sg.id]
    from_port       = var.web_port
    to_port         = var.web_port
    protocol        = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "${var.project_name}-ecs-web-sg"
  }
}

resource "aws_security_group" "ecs_app_sg" {
  name        = "${var.project_name}-ecs-app-sg"
  description = "Allow inbound from ALB to app container"
  vpc_id      = var.vpc_id

  ingress {
    security_groups = [aws_security_group.alb_sg.id]
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "${var.project_name}-ecs-app-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-db-sg"
  description = "Allow access to RDS from app instance"
  vpc_id      = var.vpc_id

  ingress {
    security_groups = [aws_security_group.ecs_app_sg.id]
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "${var.project_name}-db-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow access to HTTP/HTTPS traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}
