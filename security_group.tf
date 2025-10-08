####################################
#       MONGODD SECURITY GROUP
####################################
resource "aws_security_group" "mongodb_sg" {
  name        = "noteapp_mongodb_sg"
  description = "Allow traffic from backend API"
  vpc_id      = aws_vpc.noteapp_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "mongodb_sg_ingress" {
  security_group_id            = aws_security_group.mongodb_sg.id
  referenced_security_group_id = aws_security_group.backend_api_sg.id
  # cidr_ipv4   = aws_vpc.noteapp_vpc.cidr_block
  ip_protocol = "tcp"
  from_port   = 27017
  to_port     = 27017
}

resource "aws_vpc_security_group_egress_rule" "mongodb_sg_egress" {
  security_group_id = aws_security_group.mongodb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


####################################
#     BACKEND API SECURITY GROUP
####################################
resource "aws_security_group" "backend_api_sg" {
  name        = "noteapp_backend_sg"
  description = "Allow traffic from loadbalancer."
  vpc_id      = aws_vpc.noteapp_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "backend_api_ingress" {
  security_group_id = aws_security_group.backend_api_sg.id
  cidr_ipv4         = aws_vpc.noteapp_vpc.cidr_block
  ip_protocol       = "tcp"
  from_port         = 8000
  to_port           = 8000
}

resource "aws_vpc_security_group_egress_rule" "backend_api_egress" {
  security_group_id            = aws_security_group.backend_api_sg.id
  referenced_security_group_id = aws_security_group.mongodb_sg.id
  ip_protocol                  = "-1"
}