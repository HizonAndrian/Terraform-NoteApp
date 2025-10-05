# In order to have an ID, use the created aws subnet.
locals {
  subnet_set = [
    for i, j in aws_subnet.noteapp_subnet :
    j.id
    if var.subnet_config[i].is_public == true
  ]
}

# Task Definition (MongoDB)
resource "aws_ecs_task_definition" "mongodb_task_def" {
  family                   = "noteapp_mongodb"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  cpu                = 256 #.25
  memory             = 512 #.5
  execution_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  task_role_arn      = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "noteapp_mongodb"
      image     = "mongo"
      essential = true
      portMappings = [
        {
          containerPort = 27017
          hostPort      = 27017
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
    }
  ])
}

resource "aws_ecs_service" "mongodb_service" {
  #Task definition family.
  task_definition = aws_ecs_task_definition.mongodb_task_def.arn
  name            = "mongodb"
  cluster         = aws_ecs_cluster.noteapp_ecs_cluster.id
  desired_count   = 1

  force_new_deployment = true

  network_configuration {
    subnets         = local.subnet_set
    security_groups = [aws_security_group.mongodb_sg.id]
  }
}