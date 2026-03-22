output "network_id" {
  value = google_compute_network.transit.id
}

output "network_name" {
  value = google_compute_network.transit.name
}

output "subnet_id" {
  value = google_compute_subnetwork.transit.id
}