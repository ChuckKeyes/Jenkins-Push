resource "aws_ec2_transit_gateway_route" "shinjuku_to_sp_cidr" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shinjuku_rt01.id
  destination_cidr_block         = var.saopaulo_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id
}