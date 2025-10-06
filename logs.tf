resource "aws_cloudwatch_log_group" "ecs_noteapp_logs" {
  name              = "/mongodb/noteapp"
  skip_destroy      = false
  retention_in_days = 7
}