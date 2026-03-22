resource "aws_acm_certificate" "cf_cert" {
  provider          = aws.use1
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "${var.app_subdomain}.${var.domain_name}"
  ]
}

resource "aws_route53_record" "cf_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cf_cert.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 60
}

# resource "aws_acm_certificate_validation" "cf_cert_validation" {
#   provider                = aws.use1
#   certificate_arn         = aws_acm_certificate.cf_cert.arn
#   validation_record_fqdns = [for r in aws_route53_record.cf_cert_validation : r.fqdn]
# }

# output "cloudfront_acm_cert_arn" {
#   value = aws_acm_certificate.cf_cert.arn
# }
