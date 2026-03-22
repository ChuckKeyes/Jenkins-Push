############################################
# EC2 App Security Group (only ALB can reach it)
############################################


resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-app-sg"
  description = "App instances: only ALB can reach app port"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-app-sg"
  })
}

# Ingress: app port ONLY from the ALB SG
resource "aws_security_group_rule" "app_ingress_from_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.app_sg.id
  from_port                = var.app_port
  to_port                  = var.app_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id

  description = "Allow app port from ALB only"
}

# Egress: allow all (lab-simple)
resource "aws_security_group_rule" "app_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.app_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  description = "Allow all outbound"
}