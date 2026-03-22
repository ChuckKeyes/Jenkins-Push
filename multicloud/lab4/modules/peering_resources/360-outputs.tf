output "tgw_peering_attachment_id" {
  value = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.id
}

output "tgw_peering_attachment_status" {
  value = aws_ec2_transit_gateway_peering_attachment.tokyo_to_saopaulo.state
}