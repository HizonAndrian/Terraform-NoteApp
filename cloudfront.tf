# locals {
#   s3_origin   = "noteapp_s3_origin"
#   alb_origin  = "noteapp_backend_origin"
#   root_object = "index.html"
#   alias       = "cloudriann.com"
# }

# # Managed cache policy for dynamic API (disable caching)
# data "aws_cloudfront_cache_policy" "caching_disabled" {
#   name = "Managed-CachingDisabled"
# }

# # Managed origin request policy to forward everything to backend
# data "aws_cloudfront_origin_request_policy" "all_viewer" {
#   name = "Managed-AllViewer"
# }

# #################################
# #  ORIGIN ACCESS CONTROL (OAC)
# #################################
# resource "aws_cloudfront_origin_access_control" "noteapp_oac" {
#   name                              = "main_oac"
#   origin_access_control_origin_type = "s3"
#   signing_behavior                  = "always"
#   signing_protocol                  = "sigv4"
# }

# #################################
# #  CLOUDFRONT DISTRIBUTION
# #################################
# resource "aws_cloudfront_distribution" "noteapp_frontend_distribution" {

#   # S3 Origin
#   origin {
#     domain_name              = aws_s3_bucket.noteapp_frontend.bucket_regional_domain_name
#     origin_access_control_id = aws_cloudfront_origin_access_control.noteapp_oac.id
#     origin_id                = local.s3_origin
#   }

#   # Backend ALB Origin
#   origin {
#     domain_name = aws_lb.backend_alb.dns_name
#     origin_id = local.alb_origin
#     custom_origin_config {
#       http_port = 80
#       https_port = 443
#       origin_protocol_policy = "https-only"
#       origin_ssl_protocols = ["TLSv1.2"]
#     }
#   }

#   enabled             = true  # If this distribution is enabled.
#   is_ipv6_enabled     = false
#   default_root_object = local.root_object

#   aliases = ["${local.alias}"]

  
#   # FOR S3
#   default_cache_behavior {
#     allowed_methods = ["HEAD","GET"]
#     cached_methods  = ["GET","HEAD"]
#     target_origin_id = local.s3_origin

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "allow-all"
#     min_ttl                = 0
#     default_ttl            = 3600
#     max_ttl                = 86400
#   }


#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     acm_certificate_arn      = "arn:aws:acm:us-east-1:${data.aws_caller_identity.current.account_id}:certificate/26eb6bce-7062-4623-8598-d62775c3118b"
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2021"
#   }
# }