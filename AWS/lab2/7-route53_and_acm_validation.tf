############################################
# Bonus B - Route53 (Hosted Zone + DNS records + ACM validation)
############################################
locals {
  zone_name = var.domain_name
  app_fqdn  = "${var.app_subdomain}.${var.domain_name}"
}

data "aws_route53_zone" "primary" {
  name         = "${var.domain_name}."
  private_zone = false
}

locals {
  zone_id = data.aws_route53_zone.primary.zone_id
}

############################################
# ACM Certificate (must exist for DNS validation records)
############################################
# resource "aws_acm_certificate" "cf_cert" {
#   domain_name       = local.app_fqdn
#   validation_method = var.certificate_validation_method

#   tags = {
#     Name = "${var.project_name}-acm"
#   }
# }




############################################
# Hosted Zone (optional creation)
############################################

# resource "aws_route53_zone" "zone" {
#   count = var.manage_route53_in_terraform ? 1 : 0

#   name = local.zone_name

#   tags = {
#     Name = "${var.project_name}-zone"
#   }
# }


# data "aws_route53_zone" "existing" {
#   count        = var.manage_route53_in_terraform ? 0 : 1
#   name         = "${var.domain_name}."
#   private_zone = false
# }

############################################
# ACM DNS Validation Records
############################################

resource "aws_route53_record" "acm_validation" {
  for_each = var.certificate_validation_method == "DNS" ? {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  } : {}

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60

  records = [each.value.record]

allow_overwrite = true

}

# resource "aws_acm_certificate_validation" "cert_validation_dns" {
#   count = var.certificate_validation_method == "DNS" ? 1 : 0

#   certificate_arn = aws_acm_certificate.cert.arn

#   validation_record_fqdns = [
#     for r in aws_route53_record.acm_validation : r.fqdn
#   ]
# }
