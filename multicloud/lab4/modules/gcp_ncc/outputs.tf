#
output "hub_id" {
  value = google_network_connectivity_hub.main.id
}

output "hub_name" {
  value = google_network_connectivity_hub.main.name
}

output "iowa_spoke_id" {
  value = google_network_connectivity_spoke.iowa_spoke.id
}

output "ny_spoke_id" {
  value = google_network_connectivity_spoke.ny_spoke.id
}
