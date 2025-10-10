# RAW
locals {
  public-subnets = {
    for subnet_key, subnet_value in var.subnet_config :
    subnet_key => subnet_value
    if subnet_value.is_public == true
  }
}

locals {
  private-subnets = {
    for subnet_key, subnet_value in var.subnet_config :
    subnet_key => subnet_value
    if subnet_value.is_public == false
  }
}

# CURRENT RESOURCE
# In order to fetch the IDs of the deployed subnets, use the created aws subnets.

locals {
  private_subnet_set = [
    for k, v in aws_subnet.noteapp_subnet :
    v.id
    if var.subnet_config[k].is_public == false
  ]
}

locals {
  public_subnet_set = [
    for k, v in aws_subnet.noteapp_subnet :
    v.id
    if var.subnet_config[k].is_public == true
  ]
}


#############################
#         RESOURCES
#############################

# VPC
resource "aws_vpc" "noteapp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "noteapp_vpc"
    Description = "VPC for Note Application."
  }
}

# SUBNETS
resource "aws_subnet" "noteapp_subnet" {
  for_each          = var.subnet_config
  vpc_id            = aws_vpc.noteapp_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = each.value.subnet_tags
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "noteapp_igw" {
  vpc_id = aws_vpc.noteapp_vpc.id

  tags = {
    Name = "noteapp_igw"
  }
}

# ROUTE TABLE
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

# Public ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "noteapp_rtbl_asso" {
  for_each       = local.public-subnets
  subnet_id      = aws_subnet.noteapp_subnet[each.key].id
  route_table_id = aws_route_table.noteapp_route_tbl.id
}



#############################
#         NAT GATEWAY
#############################

# Elastic IPs
resource "aws_eip" "noteapp_NAT_eip" {
  for_each = local.public-subnets # How many EIP to create base on the number of public IPs
  domain   = "vpc"
}

#NAT GATEWAY
resource "aws_nat_gateway" "noteapp_nat_gtw" {
  for_each      = local.public-subnets
  allocation_id = aws_eip.noteapp_NAT_eip[each.key].allocation_id
  subnet_id     = aws_subnet.noteapp_subnet[each.key].id
  depends_on    = [aws_internet_gateway.noteapp_igw]

  tags = {
    Name = "noteapp_NAT_gtw"
  }
}

resource "aws_route_table" "noteapp_private_routetbl" {
  for_each = local.private-subnets
  vpc_id   = aws_vpc.noteapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = one([
      for k, v in aws_nat_gateway.noteapp_nat_gtw :
      v.id if aws_subnet.noteapp_subnet[k].availability_zone == each.value.availability_zone
    ])
  }

  tags = {
    Name = "noteapp_private_routetbl"
  }
}

resource "aws_route_table_association" "private_route_asso" {
  for_each       = local.private-subnets
  subnet_id      = aws_subnet.noteapp_subnet[each.key].id
  route_table_id = aws_route_table.noteapp_private_routetbl[each.key].id
}