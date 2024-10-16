resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "cluster_capacity" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "web"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_web_overall_cpu
  memory                   = var.ecs_task_web_overall_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = "${var.ecr_repo_url["web"]}:latest"
      cpu       = var.ecs_task_web_main_cpu
      memory    = var.ecs_task_web_main_memory
      essential = true
      portMappings = [{
        containerPort = var.web_port
      }]
      secrets = [
        {
          "name" : "REACT_APP_API_URL",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:REACT_APP_API_URL::"
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    # use ARM64 if you are pushing docker image built using M1/M2 chip
    cpu_architecture = "X86_64"
  }
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_app_overall_cpu
  memory                   = var.ecs_task_app_overall_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "${var.ecr_repo_url["app"]}:latest"
      cpu       = var.ecs_task_app_main_cpu
      memory    = var.ecs_task_app_main_memory
      essential = true
      portMappings = [{
        containerPort = var.app_port
      }]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/my-service"
          awslogs-region        = "ap-southeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }

      secrets = [
        {
          "name" : "DATABASE_URL",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:DATABASE_URL::"
        },
        {
          "name" : "FIRST_SUPER_ADMIN_EMAIL",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:FIRST_SUPER_ADMIN_EMAIL::"
        },
        {
          "name" : "FIRST_SUPER_ADMIN_PASSWORD",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:FIRST_SUPER_ADMIN_PASSWORD::"
        },
        {
          "name" : "JWT_SECRET",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:JWT_SECRET::"
        },
        {
          "name" : "AUTH_AD_TENANT_ID",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:AUTH_AD_TENANT_ID::"
        },
        {
          "name" : "AUTH_AD_CLIENT_ID",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:AUTH_AD_CLIENT_ID::"
        },
        {
          "name" : "AUTH_AD_CLIENT_SECRET",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:AUTH_AD_CLIENT_SECRET::"
        },
        {
          "name" : "AUTH_AD_REDIRECT_DOMAIN",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:AUTH_AD_REDIRECT_DOMAIN::"
        },
        {
          "name" : "AUTH_AD_COOKIE_KEY",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:AUTH_AD_COOKIE_KEY::"
        },
        {
          "name" : "AUTH_AD_COOKIE_IV",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:AUTH_AD_COOKIE_IV::"
        },
        {
          "name" : "FRONT_END_HOST",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:FRONT_END_HOST::"
        },
        {
          "name" : "DD_ENV",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:DD_ENV::"
        },
        {
          "name" : "DD_LOGS_INJECTION",
          "valueFrom" : "${var.aws_secretsmanager_secret_arn}:DD_LOGS_INJECTION::"
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    # use ARM64 if you are pushing docker image built using M1/M2 chip
    cpu_architecture = "X86_64"
  }
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/my-service"
  retention_in_days = 3 # Set log retention as needed
}

resource "aws_ecs_service" "web" {
  name                              = "web-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.web.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 15
  enable_execute_command            = true
  force_new_deployment              = true

  network_configuration {
    assign_public_ip = false
    subnets          = var.web_subnets
    security_groups  = var.web_security_groups
  }

  load_balancer {
    target_group_arn = var.web_target_group_arn
    container_name   = "web"
    container_port   = var.web_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}

resource "aws_ecs_service" "app" {
  name                              = "app-service"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.app.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 15
  enable_execute_command            = true
  force_new_deployment              = true

  network_configuration {
    assign_public_ip = false
    subnets          = var.app_subnets
    security_groups  = var.app_security_groups
  }

  load_balancer {
    target_group_arn = var.app_target_group_arn
    container_name   = "app"
    container_port   = var.app_port
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
}

## ECS IAM
# Execution Role (ECSTaskExecutionRolePolicy/SecretsManagerReadWrite)
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_task_execution" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "execution_role_secrets_access" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}
