locals {
  public-subnets = {
    for subnet_key, subnet_value in var.subnet_config :
    subnet_key => subnet_value
    if subnet_value.is_public == true
  }
}

data "aws_region" "current" {}

resource "aws_vpc" "noteapp_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "noteapp_vpc"
    Description = "VPC for Note Application."
  }
}

resource "aws_subnet" "noteapp_subnet" {
  for_each   = var.subnet_config
  vpc_id     = aws_vpc.noteapp_vpc.id
  cidr_block = each.value.cidr_block

  tags = each.value.subnet_tags
}

resource "aws_internet_gateway" "noteapp_igw" {
  vpc_id = aws_vpc.noteapp_vpc.id

  tags = {
    Name = "noteapp_igw"
  }
}

resource "aws_route_table" "noteapp_route_tbl" {
  vpc_id = aws_vpc.noteapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.noteapp_igw.id
  }

  tags = {
    Name = "noteapp_route_tbl"
  }
}

resource "aws_route_table_association" "noteapp_rtbl_asso" {
  for_each       = local.public-subnets
  subnet_id      = aws_subnet.noteapp_subnet[each.key].id
  route_table_id = aws_route_table.noteapp_route_tbl.id
}