

# Only build ALB if enabled
resource "aws_lb" "this" {
  count              = var.alb_enable ? 1 : 0
  name               = local.alb_name
  internal            = false
  load_balancer_type = "application"
  subnets            = [for s in aws_subnet.public : s.id]
  security_groups    = [aws_security_group.web.id] # allow 80/443 from world in lab mode
  idle_timeout       = 60
  # tags               = merge(var.tags, { Name = local.alb_name })
  tags = merge(var.tags, { Name = "${local.name}-alb" })
}


resource "aws_lb_listener" "http" {
  count             = var.alb_enable ? 1 : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web[0].arn
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count            = var.alb_enable ? 1 : 0
  target_group_arn = aws_lb_target_group.web[0].arn
  target_id        = aws_instance.web.id
  port             = 80
}

# https://docs.aws.amazon.com/autoscaling/ec2/userguide/tutorial-ec2-auto-scaling-load-balancer.html