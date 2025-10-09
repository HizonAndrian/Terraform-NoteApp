data "aws_route53_zone" "data_alb_dns" {
  name = "cloudriann.com"
  private_zone = false
}

resource "aws_route53_record" "noteapp_alb_dns" {
  zone_id = data.aws_route53_zone.data_alb_dns.id
  name = "api.cloudriann.com"
  type = "A"
  
  alias {
    name = aws_lb.backend_alb.dns_name
    zone_id = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}