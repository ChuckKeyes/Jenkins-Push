############################################
# Step 8 — ACM Certificate for CloudFront (us-east-1)
# - Cert lives in us-east-1 (required by CloudFront)
# - DNS validation records live in your Route53 public zone
############################################

resource "aws_acm_certificate" "cf_cert" {
  provider = aws.use1

  domain_name               = var.domain_name
  subject_alternative_names = [local.app_fqdn]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-cf-viewer-cert"
  })
}

# Create DNS validation records in Route53 (global service, no provider alias needed)
resource "aws_route53_record" "cf_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cf_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = local.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "cf_cert_validation" {
  provider = aws.use1

  certificate_arn         = aws_acm_certificate.cf_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cf_cert_validation : r.fqdn]
}

output "cloudfront_viewer_cert_arn" {
  value = aws_acm_certificate.cf_cert.arn
}