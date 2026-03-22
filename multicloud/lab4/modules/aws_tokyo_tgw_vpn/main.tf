resource "aws_customer_gateway" "gcp_cgw_1" {
  provider   = aws.tokyo
  bgp_asn    = var.customer_bgp_asn
  ip_address = var.customer_gw_ip_1
  type       = "ipsec.1"

  tags = merge(var.tags, {
    Name = "tokyo-gcp-cgw-1"
  })
}

resource "aws_customer_gateway" "gcp_cgw_2" {
  provider   = aws.tokyo
  bgp_asn    = var.customer_bgp_asn
  ip_address = var.customer_gw_ip_2
  type       = "ipsec.1"

  tags = merge(var.tags, {
    Name = "tokyo-gcp-cgw-2"
  })
}

resource "aws_vpn_connection" "gcp_to_tokyo_1" {
  provider = aws.tokyo

  customer_gateway_id = aws_customer_gateway.gcp_cgw_1.id
  transit_gateway_id  = var.tokyo_tgw_id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = merge(var.tags, {
    Name = "gcp-to-tokyo-vpn-1"
  })
}

resource "aws_vpn_connection" "gcp_to_tokyo_2" {
  provider = aws.tokyo

  customer_gateway_id = aws_customer_gateway.gcp_cgw_2.id
  transit_gateway_id  = var.tokyo_tgw_id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = merge(var.tags, {
    Name = "gcp-to-tokyo-vpn-2"
  })
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpn1_propagation" {
  provider = aws.tokyo

  transit_gateway_attachment_id  = aws_vpn_connection.gcp_to_tokyo_1.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.tokyo_tgw_route_table_id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "vpn2_propagation" {
  provider = aws.tokyo

  transit_gateway_attachment_id  = aws_vpn_connection.gcp_to_tokyo_2.transit_gateway_attachment_id
  transit_gateway_route_table_id = var.tokyo_tgw_route_table_id
}