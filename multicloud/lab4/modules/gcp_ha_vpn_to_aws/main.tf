resource "google_compute_router" "router" {
  name    = var.router_name
  project = var.project_id
  region  = var.region
  network = var.network_id

  bgp {
    asn = var.router_asn
  }
}

resource "google_compute_ha_vpn_gateway" "gcp_ha_vpn" {
  name    = var.ha_vpn_gateway_name
  project = var.project_id
  region  = var.region
  network = var.network_id
}

resource "google_compute_external_vpn_gateway" "aws" {
  name            = var.aws_external_gw_name
  project         = var.project_id
  redundancy_type = "FOUR_IPS_REDUNDANCY"

  interface {
    id         = 0
    ip_address = var.aws_peer_ip_1
  }

  interface {
    id         = 1
    ip_address = var.aws_peer_ip_2
  }

  interface {
    id         = 2
    ip_address = var.aws_peer_ip_3
  }

  interface {
    id         = 3
    ip_address = var.aws_peer_ip_4
  }
}