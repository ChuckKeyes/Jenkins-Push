############################################
# Step 7 — Route53 zone lookup + locals
############################################

# variable "domain_name" {
#   description = "Base domain (example: keyescloudsolutions.com)"
#   type        = string
# }

# variable "app_subdomain" {
#   description = "Subdomain label (example: www or app)"
#   type        = string
#   default     = "www"
# }

data "aws_route53_zone" "primary" {
  name         = "${var.domain_name}."
  private_zone = false
}

locals {
  zone_id  = data.aws_route53_zone.primary.zone_id
  app_fqdn = "${var.app_subdomain}.${var.domain_name}"
}

# # www -> CloudFront
# resource "aws_route53_record" "app_a" {
#   zone_id = local.zone_id
#   name    = local.app_fqdn
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.cf.domain_name
#     zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "app_aaaa" {
#   zone_id = local.zone_id
#   name    = local.app_fqdn
#   type    = "AAAA"

#   alias {
#     name                   = aws_cloudfront_distribution.cf.domain_name
#     zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# # apex -> www (so keyescloudsolutions.com goes to the same place)
# resource "aws_route53_record" "root_a" {
#   zone_id = local.zone_id
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name                   = aws_route53_record.app_a.fqdn
#     zone_id                = local.zone_id
#     evaluate_target_health = false
#   }
# }

########################################################################################

# resource "aws_route53_record" "www_a" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "www.keyescloudsolutions.com"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.cf.domain_name
#     zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "www_aaaa" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "www.keyescloudsolutions.com"
#   type    = "AAAA"

#   alias {
#     name                   = aws_cloudfront_distribution.cf.domain_name
#     zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "root_a" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "keyescloudsolutions.com"
#   type    = "A"

#   alias {
#     name                   = aws_cloudfront_distribution.cf.domain_name
#     zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
#     evaluate_target_health = false
#   }
# }

# resource "aws_route53_record" "root_aaaa" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "keyescloudsolutions.com"
#   type    = "AAAA"

#   alias {
#     name                   = aws_cloudfront_distribution.cf.domain_name
#     zone_id                = aws_cloudfront_distribution.cf.hosted_zone_id
#     evaluate_target_health = false
#   }
# }