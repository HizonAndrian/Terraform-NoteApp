# Namespace for Service discovery
resource "aws_service_discovery_private_dns_namespace" "noteapp_namespace" {
  name        = "noteapp_namespace"
  description = "Name space for Note Application"
  vpc         = aws_vpc.noteapp_vpc.id
}

resource "aws_service_discovery_service" "mongodb_discovery_service" {
  name = "mongodb_service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.noteapp_namespace.id

    dns_records {
      ttl  = 300
      type = "A"
    }
  }

  force_destroy = true
}