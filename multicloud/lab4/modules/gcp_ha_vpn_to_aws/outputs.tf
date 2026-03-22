output "router_name" {
  value = google_compute_router.router.name
}

output "ha_vpn_gateway_id" {
  value = google_compute_ha_vpn_gateway.gcp_ha_vpn.id
}

output "ha_vpn_gateway_self_link" {
  value = google_compute_ha_vpn_gateway.gcp_ha_vpn.self_link
}

output "vpn_interface_0_ip" {
  value = google_compute_ha_vpn_gateway.gcp_ha_vpn.vpn_interfaces[0].ip_address
}

output "vpn_interface_1_ip" {
  value = google_compute_ha_vpn_gateway.gcp_ha_vpn.vpn_interfaces[1].ip_address
}