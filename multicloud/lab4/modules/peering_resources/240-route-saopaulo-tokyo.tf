resource "aws_ec2_transit_gateway_route" "saopaulo_to_tokyo_route" {
  provider = aws.saopaulo

  transit_gateway_route_table_id = var.saopaulo_tgw_route_table_id
  destination_cidr_block         = var.tokyo_vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.saopaulo_accept
  ]
}