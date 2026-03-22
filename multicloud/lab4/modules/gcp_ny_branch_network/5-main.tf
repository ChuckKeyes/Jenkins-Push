resource "google_compute_network" "ny_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
   routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "ny_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.ny_vpc.id
}