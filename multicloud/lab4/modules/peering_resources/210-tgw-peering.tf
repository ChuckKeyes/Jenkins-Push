resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_to_saopaulo" {
  provider = aws

  transit_gateway_id      = var.tokyo_tgw_id
  peer_transit_gateway_id = var.saopaulo_tgw_id
  peer_region             = "sa-east-1"

  tags = merge(var.tags, {
    Name = "${var.project_name}-tokyo-to-saopaulo-peer"
  })
}