output "saopaulo_tgw_id" {
  value = aws_ec2_transit_gateway.saopaulo_tgw.id
}

output "saopaulo_tgw_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.saopaulo_tgw_rt.id
}

output "saopaulo_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.saopaulo_vpc_attachment.id
}

output "tgw_id" {
  value = aws_ec2_transit_gateway.saopaulo_tgw.id
}

output "tgw_route_table_id" {
  value = aws_ec2_transit_gateway_route_table.saopaulo_tgw_rt.id
}

output "tgw_vpc_attachment_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.saopaulo_vpc_attachment.id
}