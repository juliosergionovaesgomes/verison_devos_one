# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "localstack-cluster"

  tags = {
    Name        = "localstack-cluster"
    Environment = "localstack"
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "verison-devos-one"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn           = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name  = "verison-devos-one"
      image = "${aws_ecr_repository.app_repo.repository_url}:latest"
      
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "verison-devos-one"
    Environment = "localstack"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/verison-devos-one"
  retention_in_days = 7

  tags = {
    Name        = "verison-devos-one-logs"
    Environment = "localstack"
  }
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "verison-devos-one-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  tags = {
    Name        = "verison-devos-one-service"
    Environment = "localstack"
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_execution_role_policy]
}