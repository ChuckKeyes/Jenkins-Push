output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "private_subnet_ids" {
  value = [for s in aws_subnet.private_app : s.id]
}

output "private_route_table_ids" {
  value = [aws_route_table.private_app.id]
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}

output "app_instance_id" {
  value = aws_instance.app.id
}

