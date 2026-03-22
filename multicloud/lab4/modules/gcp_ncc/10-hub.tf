#
resource "google_network_connectivity_hub" "main" {
  name        = var.hub_name
  project     = var.project_id
  description = var.hub_description
  labels      = var.labels
}