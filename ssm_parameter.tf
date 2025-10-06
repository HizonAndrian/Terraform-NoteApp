#MongoDB SSM Parameter
resource "aws_ssm_parameter" "MONGO_INITDB_DATABASE" {
  name  = "/noteapp/mongo/MONGO_INITDB_DATABASE"
  type  = "String"
  value = var.ssm_db_credentials["MONGO_INITDB_DATABASE"]
}

resource "aws_ssm_parameter" "MONGO_INITDB_ROOT_USERNAME" {
  name  = "/noteapp/mongo/MONGO_INITDB_ROOT_USERNAME"
  type  = "String"
  value = var.ssm_db_credentials["MONGO_INITDB_ROOT_USERNAME"]
}

resource "aws_ssm_parameter" "MONGO_INITDB_ROOT_PASSWORD" {
  name  = "/noteapp/mongo/MONGO_INITDB_ROOT_PASSWORD"
  type  = "SecureString"
  value = var.ssm_db_credentials["MONGO_INITDB_ROOT_PASSWORD"]
}


#Backend SSM Parameter
resource "aws_ssm_parameter" "MONGO_USERNAME" {
  name  = "/noteapp/backend/MONGO_USERNAME"
  type  = "String"
  value = var.ssm_backend_variables["MONGO_USERNAME"]
}

resource "aws_ssm_parameter" "MONGO_PASSWORD" {
  name  = "/noteapp/backend/MONGO_PASSWORD"
  type  = "SecureString"
  value = var.ssm_backend_variables["MONGO_PASSWORD"]
}

resource "aws_ssm_parameter" "MONGO_DB" {
  name  = "/noteapp/backend/MONGO_DB"
  type  = "String"
  value = var.ssm_backend_variables["MONGO_DB"]
}

resource "aws_ssm_parameter" "MONGO_PORT" {
  name  = "/noteapp/backend/MONGO_PORT"
  type  = "String"
  value = var.ssm_backend_variables["MONGO_DB"]
}

resource "aws_ssm_parameter" "MONGO_HOST" {
  name  = "/noteapp/backend/MONGO_HOST"
  type  = "String"
  value = "${aws_service_discovery_service.mongodb_discovery_service.name}.${aws_service_discovery_private_dns_namespace.noteapp_namespace.name}"
}