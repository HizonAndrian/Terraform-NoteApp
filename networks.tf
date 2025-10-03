data "aws_region" "current" {}

resource "aws_vpc" "noteapp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name       = "noteapp_vpc"
    Desciption = "VPC for Note Application."
  }
}

resource "aws_subnet" "name" {
  for_each   = var.subnet_config
  vpc_id     = aws_vpc.noteapp_vpc.id
  cidr_block = each.value.cidr_block

  tags = each.value.subnet_tags
}