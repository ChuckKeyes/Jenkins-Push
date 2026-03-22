output "tokyo_tgw_id" {
  value = aws_ec2_transit_gateway.tokyo_tgw.id
}

output "tokyo_tgw_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.tokyo_tgw_rt.id
}

output "tokyo_tgw_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attachment.id
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.tokyo_tgw.id
}

output "tgw_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.tokyo_tgw_rt.id
}

output "tgw_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.tokyo_vpc_attachment.id
}