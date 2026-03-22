resource "google_compute_vpn_tunnel" "tunnel_1" {
  name                            = "gcp-to-aws-tunnel-1"
  project                         = var.project_id
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp_ha_vpn.id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 0
  shared_secret                   = "TkUy5c_rNNzDb3VnI4L9iEA2YomJxB6N"
  router                          = google_compute_router.router.name
}
##########################################################################
resource "google_compute_vpn_tunnel" "tunnel_2" {
  name                            = "gcp-to-aws-tunnel-2"
  project                         = var.project_id
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp_ha_vpn.id
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 1
  shared_secret                   = "vwFOchTT0txsHBEXw_Y8aaMPkuHrv6kZ"
  router                          = google_compute_router.router.name
}
##############################################################################
resource "google_compute_vpn_tunnel" "tunnel_3" {
  name                            = "gcp-to-aws-tunnel-3"
  project                         = var.project_id
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp_ha_vpn.id
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 2
  shared_secret                   = "gbMn.Bq6hbe89c0hD8zhD.jiWgVQdfLQ"
  router                          = google_compute_router.router.name
}
#############################################################################
resource "google_compute_vpn_tunnel" "tunnel_4" {
  name                            = "gcp-to-aws-tunnel-4"
  project                         = var.project_id
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp_ha_vpn.id
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.aws.id
  peer_external_gateway_interface = 3
  shared_secret                   = "SruVZAoMviUGN6UzrdR1Leh21YG9.f56"
  router                          = google_compute_router.router.name
}
################################################################################
################################################################################
#                   router interfaces and BGP peers
################################################################################
###############################################################################

resource "google_compute_router_interface" "if_tunnel_1" {
  name       = "if-tunnel-1"
  project    = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
  ip_range   = "169.254.254.178/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_1.name
}

resource "google_compute_router_peer" "peer_tunnel_1" {
  name            = "peer-tunnel-1"
  project         = var.project_id
  region          = var.region
  router          = google_compute_router.router.name
  interface       = google_compute_router_interface.if_tunnel_1.name
  peer_ip_address = "169.254.254.177"
  peer_asn        = 64512
}
################################################################################
resource "google_compute_router_interface" "if_tunnel_2" {
  name       = "if-tunnel-2"
  project    = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
  ip_range   = "169.254.245.174/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_2.name
}

resource "google_compute_router_peer" "peer_tunnel_2" {
  name            = "peer-tunnel-2"
  project         = var.project_id
  region          = var.region
  router          = google_compute_router.router.name
  interface       = google_compute_router_interface.if_tunnel_2.name
  peer_ip_address = "169.254.245.173"
  peer_asn        = 64512
}
##################################################################################
resource "google_compute_router_interface" "if_tunnel_3" {
  name       = "if-tunnel-3"
  project    = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
  ip_range   = "169.254.176.198/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_3.name
}

resource "google_compute_router_peer" "peer_tunnel_3" {
  name            = "peer-tunnel-3"
  project         = var.project_id
  region          = var.region
  router          = google_compute_router.router.name
  interface       = google_compute_router_interface.if_tunnel_3.name
  peer_ip_address = "169.254.176.197"
  peer_asn        = 64512
}
#################################################################
resource "google_compute_router_interface" "if_tunnel_4" {
  name       = "if-tunnel-4"
  project    = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
  ip_range   = "169.254.136.254/30"
  vpn_tunnel = google_compute_vpn_tunnel.tunnel_4.name
}

resource "google_compute_router_peer" "peer_tunnel_4" {
  name            = "peer-tunnel-4"
  project         = var.project_id
  region          = var.region
  router          = google_compute_router.router.name
  interface       = google_compute_router_interface.if_tunnel_4.name
  peer_ip_address = "169.254.136.253"
  peer_asn        = 64512
}
