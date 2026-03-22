resource "google_compute_network" "transit" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "transit" {
  name          = var.subnet_name
  project       = var.project_id
  region        = var.region
  network       = google_compute_network.transit.id
  ip_cidr_range = var.subnet_cidr
}