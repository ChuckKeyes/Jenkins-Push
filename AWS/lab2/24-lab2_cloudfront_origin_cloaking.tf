# Explanation: Chewbacca only opens the hangar to CloudFront — everyone else gets the Wookiee roar.
data "aws_ec2_managed_prefix_list" "cf_origin_facing" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}


# Explanation: Only CloudFront origin-facing IPs may speak to the ALB — direct-to-ALB attacks die here.
resource "aws_security_group_rule" "alb_ingress_cf_443" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_sg.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"

  prefix_list_ids = [
    data.aws_ec2_managed_prefix_list.cf_origin_facing.id
  ]
}



# Explanation: This is Chewbacca’s secret handshake — if the header isn’t present, you don’t get in.
resource "random_password" "origin_header_value" {
  length  = 32
  special = false
}



# Explanation: ALB checks for Chewbacca’s secret growl — no growl, no service.
resource "aws_lb_listener_rule" "require_origin_header" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }

  condition {
    http_header {
      http_header_name = "X-Origin-Verify"
      values           = [random_password.origin_header_value.result]
    }
  }
}

# Explanation: If you don’t know the growl, you get a 403 — Chewbacca does not negotiate.
resource "aws_lb_listener_rule" "default_block" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 99

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }

  condition {
    path_pattern {
       values = ["*"] 
       }
  }
}