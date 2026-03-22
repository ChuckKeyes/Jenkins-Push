############################################
# ALB + Target Group + Listeners (Tokyo)
############################################

variable "alb_acm_cert_arn" {
  description = "ACM cert ARN in the ALB region (Tokyo) for HTTPS listener"
  type        = string
}

# variable "origin_header_name" {
#   description = "Header name CloudFront adds so ALB can verify requests"
#   type        = string
#   default     = "X-Origin-Verify"
# }

# variable "origin_header_value" {
#   description = "Header value CloudFront adds; ALB blocks requests missing this"
#   type        = string
#   sensitive   = true
# }

resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  # ALB must be in PUBLIC subnets
  subnets         = [for s in aws_subnet.public : s.id]
  security_groups = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.project_name}-alb"
  })
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.project_name}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-tg"
  })
}

# Optional: HTTP -> HTTPS redirect (recommended)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"

  certificate_arn = aws_acm_certificate.alb_cert.arn
  depends_on      = [aws_acm_certificate_validation.alb_cert_validation]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "allow_cloudfront_origin_header" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    http_header {
      http_header_name = var.origin_header_name
      values           = [var.origin_header_value]  # ✅ module input
    }
  }
}