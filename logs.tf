resource "aws_cloudwatch_log_group" "ecs_mongodb_logs" {
  name              = "/mongodb/noteapp"
  skip_destroy      = false
  retention_in_days = 7
}

moved {
  from = aws_cloudwatch_log_group.ecs_noteapp_logs
  to   = aws_cloudwatch_log_group.ecs_mongodb_logs
}

resource "aws_cloudwatch_log_group" "ecs_backend_logs" {
  name              = "/backend/noteapp"
  skip_destroy      = false
  retention_in_days = 7
}