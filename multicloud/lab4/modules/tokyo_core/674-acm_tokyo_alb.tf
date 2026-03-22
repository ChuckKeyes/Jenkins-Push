############################################
# ACM Certificate for ALB (Tokyo / ap-northeast-1)
############################################

resource "aws_acm_certificate" "alb_cert" {
  # default provider is Tokyo (ap-northeast-1)
  domain_name               = local.app_fqdn
  subject_alternative_names = [var.domain_name] # optional: include apex too
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-alb-cert-tokyo"
  })
}

# DNS validation records in Route53
resource "aws_route53_record" "alb_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id         = local.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "alb_cert_validation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.alb_cert_validation : r.fqdn]
}

output "alb_cert_arn_tokyo" {
  value = aws_acm_certificate.alb_cert.arn
}