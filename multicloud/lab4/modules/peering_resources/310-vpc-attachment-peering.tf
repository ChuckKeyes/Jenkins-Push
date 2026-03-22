resource "aws_ec2_transit_gateway_route_table_association" "saopaulo_peer_assoc" {
  provider = aws.saopaulo

  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id
  transit_gateway_route_table_id = var.saopaulo_tgw_route_table_id

  depends_on = [
    aws_ec2_transit_gateway_peering_attachment_accepter.saopaulo_accept
  ]
}