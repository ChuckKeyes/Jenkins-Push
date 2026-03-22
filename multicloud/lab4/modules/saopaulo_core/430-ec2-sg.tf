#
############################################
# São Paulo App EC2 Security Group
############################################

resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for Sao Paulo app EC2"
  vpc_id      = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-app-sg"
    }
  )
}

############################################
# Ingress
############################################

# TEMP: allow HTTP for testing.
# Later, tighten this to ALB SG only or specific sources.
resource "aws_security_group_rule" "app_http_in" {
  type              = "ingress"
  security_group_id = aws_security_group.app_sg.id

  from_port   = var.app_port
  to_port     = var.app_port
  protocol    = "tcp"
  # cidr_blocks = ["10.20.0.0/16"]
  source_security_group_id = aws_security_group.alb_sg.id
}

############################################
# Egress
############################################

# Allow all outbound for now.
# This lets Sao Paulo app reach Tokyo later over TGW.
resource "aws_security_group_rule" "app_all_egress" {
  type              = "egress"
  security_group_id = aws_security_group.app_sg.id

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}