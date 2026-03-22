############################################
# ALB Security Group (locked to CloudFront)
############################################

# AWS-managed prefix list for CloudFront -> origins
data "aws_ec2_managed_prefix_list" "cloudfront_origin_facing" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "ALB ingress only from CloudFront origin-facing prefix list"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-alb-sg"
  })
}

# Ingress: HTTPS only from CloudFront origin-facing prefix list
# resource "aws_security_group_rule" "alb_ingress_https_from_cloudfront" {
#   type              = "ingress"
#   security_group_id = aws_security_group.alb_sg.id

#   from_port = 443
#   to_port   = 443
#   protocol  = "tcp"

#   prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront_origin_facing.id]

#   description = "Allow HTTPS from CloudFront origin-facing"
# }

# Egress: allow all (simple lab default)
resource "aws_security_group_rule" "alb_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow all outbound"
}

resource "aws_security_group_rule" "alb_ingress_https_from_world" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Allow HTTPS from internet; access is enforced by secret header rule"
}