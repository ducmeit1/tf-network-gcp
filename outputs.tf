output "network" {
    description = "The network was created."
    value       = {
        name            = google_compute_network.default.name,
        self_link       = google_compute_network.default.self_link,
        gateway_ipv4    = google_compute_network.default.gateway_ipv4
        routing_mode    = var.routing_mode
    }
}

output "subnetwork" {
    description = "The list of Subnetworks were created."
    value       = [
        for subnet in google_compute_subnetwork.default: {
            name                = subnet.name
            ip_cidr_range       = subnet.ip_cidr_range
            gateway_address     = subnet.gateway_address
            self_link           = subnet.self_link
        }
            
    ]
}

output "router" {
    description = "The list of Routers were created."
    value       = [
        for router in google_compute_router.default: {
            name        = router.name
            region      = router.region
            self_link   = router.self_link
        }
    ]
}