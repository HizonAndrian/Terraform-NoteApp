#############################
#       NETWORKS LOCAL
#############################

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

# LIST
locals {
  private_subnet_set = [
    for k, v in aws_subnet.noteapp_subnet :
    v.id
    if var.subnet_config[k].is_public == false
  ]
}

# LIST
locals {
  public_subnet_set = [
    for k, v in aws_subnet.noteapp_subnet :
    v.id
    if var.subnet_config[k].is_public == true
  ]
}


# MAP
locals {
  public_subnet_map = {
    for k, v in aws_subnet.noteapp_subnet :
    k => v.id
    if var.subnet_config[k].is_public == true
  }
}

#############################
#         S3 LOCALS
#############################
locals {
  frontend_files = {
    "index.html" = "text/html",
    "script.js"  = "application/javascript",
    "style.css"  = "text/css"
  }
}
