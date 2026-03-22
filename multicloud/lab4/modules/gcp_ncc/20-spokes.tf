#
resource "google_network_connectivity_spoke" "iowa_spoke" {
  name    = "${var.hub_name}-iowa-spoke"
  project = var.project_id
  hub     = google_network_connectivity_hub.main.id
  location = "global"

  linked_vpc_network {
    uri = var.iowa_network_uri
  }

  labels = var.labels
}

resource "google_network_connectivity_spoke" "ny_spoke" {
  name    = "${var.hub_name}-ny-spoke"
  project = var.project_id
  hub     = google_network_connectivity_hub.main.id
  location = "global"

  linked_vpc_network {
    uri = var.ny_network_uri
  }

  labels = var.labels
}
