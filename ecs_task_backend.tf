#Task Definition (Backend API)
resource "aws_ecs_task_definition" "backendAPI_task_def" {
  family                   = "backendAPI"
  task_role_arn            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256 #.25
  memory                   = 512 #.5 
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"

  }
  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-southeast-1.amazonaws.com/noteapp_img_repo:1"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
    }
  ])
}