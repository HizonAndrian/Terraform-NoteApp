#Task Definition (Backend API)
resource "aws_ecs_task_definition" "backendAPI_task_def" {
  family                   = "backendAPI"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 #.25
  memory                   = 512 #.5 
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current_region.id}.amazonaws.com/${aws_ecr_repository.noteapp_ecr.name}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      environment = [
        {
          name  = "MONGO_USERNAME"
          value = aws_ssm_parameter.MONGO_USERNAME.value
        },
        {
          name  = "MONGO_PASSWORD"
          value = aws_ssm_parameter.MONGO_PASSWORD.value
        },
        {
          name  = "MONGO_DB"
          value = aws_ssm_parameter.MONGO_DB.value
        },
        {
          name  = "MONGO_PORT"
          value = aws_ssm_parameter.MONGO_PORT.value
        },
        {
          name  = "MONGO_HOST"
          value = aws_ssm_parameter.MONGO_HOST.value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_backend_logs.name
          awslogs-region        = data.aws_region.current_region.id
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend_service" {
  task_definition = aws_ecs_task_definition.backendAPI_task_def.arn
  name            = "backendAPI"
  cluster         = aws_ecs_cluster.noteapp_ecs_cluster.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  force_new_deployment = true

  network_configuration {
    subnets          = local.private_subnet_set
    assign_public_ip = false
    security_groups  = [aws_security_group.backend_api_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.noteapp_backend_tg.arn
    container_name   = "backend"
    container_port   = 8000
  }

  depends_on = [aws_lb_listener.noteapp_alb_listener]
}