output "cloudfront_distribution_id" {
  value = module.edge_public.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  value = module.edge_public.cloudfront_domain_name
}

output "origin_header_value" {
  value     = module.edge_public.origin_header_value
  sensitive = true
}

output "app_fqdn" {
  value = "www.keyescloudsolutions.com"
}

output "tokyo_customer_gateway_1_id" {
  value = module.aws_tokyo_tgw_vpn.customer_gateway_1_id
}

output "tokyo_customer_gateway_2_id" {
  value = module.aws_tokyo_tgw_vpn.customer_gateway_2_id
}

output "tokyo_vpn_connection_1_id" {
  value = module.aws_tokyo_tgw_vpn.vpn_connection_1_id
}

output "tokyo_vpn_connection_2_id" {
  value = module.aws_tokyo_tgw_vpn.vpn_connection_2_id
}

# output "tokyo_vpn1_tunnel1_address" {
#   value = module.aws_tokyo_tgw_vpn.vpn1_tunnel1_address
# }

# output "tokyo_vpn1_tunnel2_address" {
#   value = module.aws_tokyo_tgw_vpn.vpn1_tunnel2_address
# }

# output "tokyo_vpn2_tunnel1_address" {
#   value = module.aws_tokyo_tgw_vpn.vpn2_tunnel1_address
# }

# output "tokyo_vpn2_tunnel2_address" {
#   value = module.aws_tokyo_tgw_vpn.vpn2_tunnel2_address
# }

output "gcp_ha_vpn_interface_0_ip" {
  value = module.gcp_ha_vpn_to_aws.vpn_interface_0_ip
}

output "gcp_ha_vpn_interface_1_ip" {
  value = module.gcp_ha_vpn_to_aws.vpn_interface_1_ip
}