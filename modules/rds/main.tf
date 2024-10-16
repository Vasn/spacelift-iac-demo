resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-db"
  allocated_storage      = var.db_allocated_storage
  db_name                = var.db_name
  engine                 = var.db_engine_type
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.postgres16"
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = false # single-az for free tier
  storage_type           = var.db_storage_type
  vpc_security_group_ids = var.db_sg_ids
  db_subnet_group_name   = aws_db_subnet_group.db_group.name

  tags = {
    Name = "${var.project_name}-db-postgresql"
  }
}

resource "aws_db_subnet_group" "db_group" {
  name       = "${var.project_name}-rds-group"
  subnet_ids = var.db_subnets

  tags = {
    Name = "${var.project_name}-rds-group"
  }
}