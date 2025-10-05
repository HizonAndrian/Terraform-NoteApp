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