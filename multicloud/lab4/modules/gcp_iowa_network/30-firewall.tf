resource "google_compute_firewall" "allow_internal" {
  name    = "${var.network_name}-internal"
  network = google_compute_network.iowa_vpc.name

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.iowa_vpc_cidr,
    var.ny_vpc_cidr
  ]
}

resource "google_compute_firewall" "allow_ssh_iap" {
  name    = "${var.network_name}-allow-ssh-iap"
  network = google_compute_network.iowa_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["iowa-test"]
}