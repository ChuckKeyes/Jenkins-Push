output "customer_gateway_1_id" {
  value = aws_customer_gateway.gcp_cgw_1.id
}

output "customer_gateway_2_id" {
  value = aws_customer_gateway.gcp_cgw_2.id
}

output "vpn_connection_1_id" {
  value = aws_vpn_connection.gcp_to_tokyo_1.id
}

output "vpn_connection_2_id" {
  value = aws_vpn_connection.gcp_to_tokyo_2.id
}

output "vpn_tunnel1_address_vpn1" {
  value = aws_vpn_connection.gcp_to_tokyo_1.tunnel1_address
}

output "vpn_tunnel2_address_vpn1" {
  value = aws_vpn_connection.gcp_to_tokyo_1.tunnel2_address
}

output "vpn_tunnel1_address_vpn2" {
  value = aws_vpn_connection.gcp_to_tokyo_2.tunnel1_address
}

output "vpn_tunnel2_address_vpn2" {
  value = aws_vpn_connection.gcp_to_tokyo_2.tunnel2_address
}