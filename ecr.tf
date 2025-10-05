data "aws_caller_identity" "current" {}

# Repository
resource "aws_ecr_repository" "noteapp_ecr" {
  name                 = "noteapp_img_repo"
  image_tag_mutability = "MUTABLE"

  force_delete = true
}

# Namespace for Service discovery
resource "aws_service_discovery_private_dns_namespace" "noteapp_namespace" {
  name        = "noteapp.namespace.local"
  description = "Name space for Note Application"
  vpc         = aws_vpc.noteapp_vpc.id
}

# Cluster
resource "aws_ecs_cluster" "noteapp_ecs_cluster" {
  name = "noteapp_cluster"
}

