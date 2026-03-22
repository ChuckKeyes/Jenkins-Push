resource "aws_ec2_transit_gateway_peering_attachment_accepter" "saopaulo_accept" {
  provider = aws.saopaulo

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id

  tags = merge(var.tags, {
    Name = "${var.project_name}-saopaulo-peer-accept"
  })
}