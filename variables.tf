variable "subnet_config" {
  type = map(object({
    cidr_block        = string
    is_public         = bool
    availability_zone = string

    subnet_tags = map(string)
  }))
}

variable "ssm_db_credentials" {
  type      = map(string)
  sensitive = true
}

variable "ssm_backend_variables" {
  type      = map(string)
  sensitive = true
}