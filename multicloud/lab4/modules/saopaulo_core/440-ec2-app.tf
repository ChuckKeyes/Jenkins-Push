#
############################################
# São Paulo App EC2
############################################

resource "aws_instance" "app" {
  ami                         = var.app_ami_id
  instance_type               = var.app_instance_type
  subnet_id                   = values(aws_subnet.private_app)[0].id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = false

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-app"
    }
  )
}