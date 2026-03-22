############################################
# Step 9 — WAFv2 for CloudFront (Global)
# MUST be created in us-east-1
############################################

resource "aws_wafv2_web_acl" "cf_waf" {
  provider = aws.use1

  name        = "${var.project_name}-cf-waf"
  description = "CloudFront WAF for ${var.project_name}"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-cf-waf"
    sampled_requests_enabled   = true
  }

  ############################################
  # AWS Managed Rule Group - Common
  ############################################
  rule {
    name     = "AWSManagedCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-common-rules"
      sampled_requests_enabled   = true
    }
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-cf-waf"
  })
}

# output "cloudfront_waf_arn" {
#   value = aws_wafv2_web_acl.cf_waf.arn
# }

