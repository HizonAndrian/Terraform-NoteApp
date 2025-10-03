variable "subnet_config" {
  type = map(object({
    cidr_block = string
    is_public  = bool

    subnet_tags = map(string)
  }))
}
