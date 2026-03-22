#
############################################
# São Paulo App EC2 Security Group
############################################

############################################
# São Paulo ALB Security Group
############################################

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for Sao Paulo ALB"
  vpc_id      = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-alb-sg"
    }
  )
}

############################################
# Ingress - HTTP
############################################

resource "aws_security_group_rule" "alb_http_in" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

############################################
# Ingress - HTTPS
############################################

resource "aws_security_group_rule" "alb_https_in" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

############################################
# Egress
############################################

resource "aws_security_group_rule" "alb_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.alb_sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}