data "aws_caller_identity" "current" {}

data "aws_region" "current_region" {}

data "aws_iam_role" "ecs_role" {
  name = "ecsTaskExecutionRole"
}

# Repository
resource "aws_ecr_repository" "noteapp_ecr" {
  name                 = "noteapp_img_repo"
  image_tag_mutability = "MUTABLE"

  force_delete = true
}

# Cluster
resource "aws_ecs_cluster" "noteapp_ecs_cluster" {
  name = "noteapp_cluster"
}

