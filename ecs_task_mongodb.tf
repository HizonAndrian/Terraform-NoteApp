# Task Definition (MongoDB)
resource "aws_ecs_task_definition" "mongodb_task_def" {
  family                   = "noteapp_mongodb"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256 #.25
  memory                   = 512 #.5
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  execution_role_arn = data.aws_iam_role.ecs_role.arn

  container_definitions = jsonencode([
    {
      name      = "noteapp_mongodb"
      image     = "mongo"
      essential = true
      portMappings = [
        {
          containerPort = 27017
          hostPort      = 27017
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "MONGO_INITDB_DATABASE"
          value = aws_ssm_parameter.MONGO_INITDB_DATABASE.value
        },
        {
          name  = "MONGO_INITDB_ROOT_USERNAME"
          value = aws_ssm_parameter.MONGO_INITDB_ROOT_USERNAME.value
        },
        {
          name  = "MONGO_INITDB_ROOT_PASSWORD"
          value = aws_ssm_parameter.MONGO_INITDB_ROOT_PASSWORD.value
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_mongodb_logs.name
          awslogs-region        = data.aws_region.current_region.id
          awslogs-stream-prefix = "mongodb"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "mongodb_service" {
  #Task definition family.
  task_definition = aws_ecs_task_definition.mongodb_task_def.arn
  name            = "mongodb"
  cluster         = aws_ecs_cluster.noteapp_ecs_cluster.id
  launch_type     = "FARGATE"
  desired_count   = 1

  force_new_deployment = true

  network_configuration {
    subnets          = local.private_subnet_set
    assign_public_ip = false
    security_groups  = [aws_security_group.mongodb_sg.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.mongodb_discovery_service.arn
  }

  depends_on = [
    aws_service_discovery_private_dns_namespace.noteapp_namespace
  ]
}