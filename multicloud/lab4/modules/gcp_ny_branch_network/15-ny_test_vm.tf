resource "google_compute_instance" "ny_test_vm" {
  name         = "ny-branch-vm01"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.ny_subnet.id
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  tags = ["ny-test"]
}