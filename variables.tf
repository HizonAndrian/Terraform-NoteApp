variable "subnet_config" {
  type = map(object({
    cidr_block = string
    is_public  = bool

    subnet_tags = map(string)
  }))
}

variable "ssm_db_credentials" {
  type      = map(string)
  sensitive = true
}
