output "network_name" {
    description = "Name of created the network."
    value = google_compute_network.network.name
}
output "network_self_link" {
    description = "Self link of created the network."
    value = google_compute_network.network.self_link
}

output "subnetwork_name" {
    description = "Name of created the sub network."
    value = google_compute_subnetwork.subnet.name
}

output "subnetwork_self_link" {
    description = "Self link of created the sub network."
    value = google_compute_subnetwork.subnet.self_link
}

output "nat_ip_addresses" {
    description = "Address of created the nat ips."
    value = google_compute_address.nat_ips.*.address
}

output "nat_ip_self_link" {
    description = "Self link of created the nat ips."
    value = google_compute_address.nat_ips.*.self_link
}

output "router_name" {
    description = "name of created the router."
    value = google_compute_router.router.name
}

output "router_self_link" {
    description = "Self link of created the router."
    value = google_compute_router.router.self_link
}