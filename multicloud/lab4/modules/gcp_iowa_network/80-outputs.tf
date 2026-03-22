output "network_id" {
  value = google_compute_network.iowa_vpc.id
}

output "network_name" {
  value = google_compute_network.iowa_vpc.name
}

output "subnet_id" {
  value = google_compute_subnetwork.iowa_subnet.id
}

output "subnet_name" {
  value = google_compute_subnetwork.iowa_subnet.name
}

output "subnet_cidr" {
  value = google_compute_subnetwork.iowa_subnet.ip_cidr_range
}

output "iowa_vm_name" {
  value = google_compute_instance.iowa_test_vm.name
}

output "iowa_vm_internal_ip" {
  value = google_compute_instance.iowa_test_vm.network_interface[0].network_ip
}

output "iowa_vpc_name" {
  value = google_compute_network.iowa_vpc.name
}