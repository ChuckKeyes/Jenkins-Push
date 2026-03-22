#  São Paulo Outputs

output "saopaulo_vpc_id" {
  value = module.saopaulo_core.vpc_id
}

output "saopaulo_private_subnets" {
  value = module.saopaulo_core.private_subnet_ids
}

output "saopaulo_app_instance_id" {
  value = module.saopaulo_core.app_instance_id
}

# Tokyo Transit Gateway

# output "tokyo_tgw_id" {
#   value = module.tokyo_tgw.tgw_id
# }

# São Paulo TGW

# output "saopaulo_tgw_id" {
#   value = module.saopaulo_tgw.tgw_id
# }

# GCP Iowa Outputs

output "iowa_vm_name" {
  value = module.iowa_network.iowa_vm_name
}

output "iowa_vm_internal_ip" {
  value = module.iowa_network.iowa_vm_internal_ip
}

# GCP NY Outputs

output "ny_vm_name" {
  value = module.ny_network.ny_vm_name
}

output "ny_vm_internal_ip" {
  value = module.ny_network.ny_vm_internal_ip
}

# Website Outputs

# output "app_fqdn" {
#   value = module.edge_public.app_fqdn
# }

# output "cloudfront_distribution_id" {
#   value = module.edge_public.cloudfront_distribution_id
# }

# output "cloudfront_domain_name" {
#   value = module.edge_public.cloudfront_domain_name
# }

output "iowa_network_id" {
  value = module.iowa_network.network_id
}

output "iowa_subnet_cidr" {
  value = module.iowa_network.subnet_cidr
}

output "ny_network_id" {
  value = module.ny_network.network_id
}

output "ny_subnet_cidr" {
  value = module.ny_network.subnet_cidr
}

output "gcp_ncc_hub_id" {
  value = module.gcp_ncc.hub_id
}

output "gcp_ncc_hub_name" {
  value = module.gcp_ncc.hub_name
}

output "gcp_ncc_iowa_spoke_id" {
  value = module.gcp_ncc.iowa_spoke_id
}

output "gcp_ncc_ny_spoke_id" {
  value = module.gcp_ncc.ny_spoke_id
}