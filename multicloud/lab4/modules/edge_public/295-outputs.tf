output "origin_header_value" {
  value     = random_password.origin_header_value.result
  sensitive = true
}

output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.cf.id
  description = "CloudFront Distribution ID"
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.cf.domain_name
  description = "CloudFront domain name (dxxxx.cloudfront.net)"
}

output "origin_header_name" {
  value = var.origin_header_name
}

output "cloudfront_waf_id" {
  value = aws_wafv2_web_acl.cf_waf.id
}

output "cloudfront_waf_arn" {
  value = aws_wafv2_web_acl.cf_waf.arn
}