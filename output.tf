output "cloudfront" {
  value = aws_route53_record.noteapp_frontend_dns.alias
}