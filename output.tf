output "current_region" {
  value = data.aws_region.current
}

output "public_subnets" {
  value = local.public-subnets
}