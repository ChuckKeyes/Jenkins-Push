############################################
# Step 12 — Origin cloaking at ALB (listener rules)
############################################

# 1) Make the HTTPS listener default action a 403 (deny by default)
#    IMPORTANT: Update your existing aws_lb_listener.https default_action
#    to match the block below.

# In your existing aws_lb_listener "https", replace default_action with this:
# default_action {
#   type = "fixed-response"
#   fixed_response {
#     content_type = "text/plain"
#     message_body = "Forbidden"
#     status_code  = "403"
#   }
# }

# 2) Allow only when the secret header matches (CloudFront will send this)
resource "aws_lb_listener_rule" "allow_only_cloudfront_header" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    http_header {
      http_header_name = var.origin_header_name
      values           = [random_password.origin_header_value.result]
    }
  }
}