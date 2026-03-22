# modules/tokyo_core/95-origin_cloaking_rules.tf

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
      values           = [var.origin_header_value]
    }
  }
}