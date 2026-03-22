############################################
# Bonus B - 1-main.tf (CLEAN CORE)
# ALB + SG + Target Group + Listeners + (optional) Access Logs + (optional) WAF + CW Alarm + Dashboard
#
# NOTE:
# - Route53 + ACM validation live in 7-route53_and_acm_validation.tf
# - S3 bucket for ALB logs lives in 15-alb_access_logs_and_dns.tf (aws_s3_bucket.alb_logs_bucket)
# - This file expects a validated ACM cert ARN passed in as var.acm_certificate_arn
############################################



data "aws_region" "current" {}

############################################
# ALB Security Group
############################################
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-alb-sg" }
}

############################################
# Allow ALB -> Private EC2 (Target SG)
############################################
resource "aws_security_group_rule" "ec2_from_alb" {
  type                     = "ingress"
  security_group_id        = var.target_ec2_sg_id
  from_port                = var.target_port
  to_port                  = var.target_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  description              = "Allow ALB to reach private EC2"
}

############################################
# ALB
############################################
resource "aws_lb" "alb" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnet_ids

  tags = { Name = "${var.project_name}-alb" }

  # Optional ALB access logs (requires aws_s3_bucket.alb_logs_bucket in another file)
  dynamic "access_logs" {
    for_each = var.enable_alb_access_logs ? [1] : []
    content {
      bucket  = aws_s3_bucket.alb_logs_bucket[0].bucket
      enabled = true
      prefix  = var.alb_access_logs_prefix
    }
  }
}

############################################
# Target Group + Attachment
############################################
resource "aws_lb_target_group" "tg" {
  name     = "${var.project_name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200-399"
  }

  tags = { Name = "${var.project_name}-tg" }
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = var.target_instance_id
  port             = var.target_port
}

############################################
# Listeners
############################################
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
  ssl_policy        = var.alb_ssl_policy
  certificate_arn = aws_acm_certificate_validation.cert_validation_dns[0].certificate_arn


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

############################################
# WAF (optional)
############################################
# resource "aws_wafv2_web_acl" "waf" {
#   count = var.enable_waf ? 1 : 0

#   name  = "${var.project_name}-waf"
#   scope = "REGIONAL"

#   default_action {
#      allow {} 
#      }

#   visibility_config {
#     cloudwatch_metrics_enabled = true
#     metric_name                = "${var.project_name}-waf"
#     sampled_requests_enabled   = true
#   }

#   rule {
#     name     = "AWSManagedRulesCommonRuleSet"
#     priority = 1

#     override_action {
#        none {} 
#        }

#     statement {
#       managed_rule_group_statement {
#         name        = "AWSManagedRulesCommonRuleSet"
#         vendor_name = "AWS"
#       }
#     }

#     visibility_config {
#       cloudwatch_metrics_enabled = true
#       metric_name                = "${var.project_name}-waf-common"
#       sampled_requests_enabled   = true
#     }
#   }
# }

# resource "aws_wafv2_web_acl_association" "waf_assoc" {
#   count = var.enable_waf ? 1 : 0

#   resource_arn = aws_lb.alb.arn
#   web_acl_arn  = aws_wafv2_web_acl.waf[0].arn
# }

############################################
# Alarm: ALB 5XX -> SNS
############################################
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_name}-alb-5xx"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.alb_5xx_eval_periods
  threshold           = var.alb_5xx_threshold
  period              = var.alb_5xx_period
  statistic           = "Sum"

  namespace   = "AWS/ApplicationELB"
  metric_name = "HTTPCode_ELB_5XX_Count"

  dimensions = {
    LoadBalancer = aws_lb.alb.arn_suffix
  }

  alarm_actions = [var.sns_topic_arn]
}

############################################
# Dashboard (simple)
############################################
resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.alb.arn_suffix],
            [".", "HTTPCode_ELB_5XX_Count", ".", aws_lb.alb.arn_suffix]
          ]
          period = 300
          stat   = "Sum"
          region = var.aws_region
          title  = "ALB: Requests + 5XX"
        }
      }
    ]
  })
}
