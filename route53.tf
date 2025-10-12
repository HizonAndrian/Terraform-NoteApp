data "aws_route53_zone" "data_alb_dns" {
  name         = "cloudriann.com"
  private_zone = false
}

resource "aws_route53_record" "noteapp_alb_dns" {
  zone_id = data.aws_route53_zone.data_alb_dns.id
  name    = "api.cloudriann.com"
  type    = "A"

  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "noteapp_frontend_dns" {
  zone_id = data.aws_route53_zone.data_alb_dns.id
  name    = "cloudriann.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.noteapp_frontend_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.noteapp_frontend_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}