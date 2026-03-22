############################################
# RDS Security Group (only EC2 app can reach it)
############################################



resource "aws_security_group" "rds_sg" {
  name        = "${var.project_name}-rds-sg"
  description = "RDS: only app SG can reach DB port"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-rds-sg"
  })
}

# Ingress: DB port only from the EC2 app SG
resource "aws_security_group_rule" "rds_ingress_from_app" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_sg.id
  from_port                = var.db_port
  to_port                  = var.db_port
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.app_sg.id

  description = "Allow DB port from app SG only"
}

# Egress: allow all (simple; also fine to omit because AWS allows all egress by default)
resource "aws_security_group_rule" "rds_egress_all" {
  type              = "egress"
  security_group_id = aws_security_group.rds_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]

  description = "Allow all outbound"
}