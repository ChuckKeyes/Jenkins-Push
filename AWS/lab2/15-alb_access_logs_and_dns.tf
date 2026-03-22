############################################
# Bonus B - Route53 (optional) + ALB Access Logs to S3
############################################



# locals {
#   fqdn = "${var.app_subdomain}.${var.domain_name}"
# }

############################################
# OPTIONAL: Route53 Zone Apex (root domain) -> ALB
# Only use this if you WANT example.com to also point to the ALB.
############################################
# resource "aws_route53_record" "apex_alias" {
#   count   = var.enable_zone_apex_alias ? 1 : 0
#   zone_id = var.route53_zone_id
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name                   = aws_lb.alb.dns_name
#     zone_id                = aws_lb.alb.zone_id
#     evaluate_target_health = true
#   }
# }

############################################
# S3 bucket for ALB access logs
############################################
resource "aws_s3_bucket" "alb_logs_bucket" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = "${var.project_name}-alb-logs-${data.aws_caller_identity.current.account_id}"

  tags = { Name = "${var.project_name}-alb-logs" }
}

resource "aws_s3_bucket_public_access_block" "alb_logs_pab" {
  count = var.enable_alb_access_logs ? 1 : 0

  bucket                  = aws_s3_bucket.alb_logs_bucket[0].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "alb_logs_owner" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs_bucket[0].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  count  = var.enable_alb_access_logs ? 1 : 0
  bucket = aws_s3_bucket.alb_logs_bucket[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.alb_logs_bucket[0].arn,
          "${aws_s3_bucket.alb_logs_bucket[0].arn}/*"
        ]
        Condition = {
          Bool = { "aws:SecureTransport" = "false" }
        }
      },
      {
        Sid    = "AllowELBPutObject"
        Effect = "Allow"
        Principal = { Service = "elasticloadbalancing.amazonaws.com" }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.alb_logs_bucket[0].arn}/${var.alb_access_logs_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
      }
    ]
  })
}
