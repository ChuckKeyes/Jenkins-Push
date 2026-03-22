output "network_id" {
  value = google_compute_network.ny_vpc.id
}

output "network_name" {
  value = google_compute_network.ny_vpc.name
}

output "subnet_id" {
  value = google_compute_subnetwork.ny_subnet.id
}

output "subnet_name" {
  value = google_compute_subnetwork.ny_subnet.name
}

output "subnet_cidr" {
  value = google_compute_subnetwork.ny_subnet.ip_cidr_range
}

output "ny_vm_name" {
  value = google_compute_instance.ny_test_vm.name
}

output "ny_vm_internal_ip" {
  value = google_compute_instance.ny_test_vm.network_interface[0].network_ip
}

output "ny_vpc_name" {
  value = google_compute_network.ny_vpc.name
}