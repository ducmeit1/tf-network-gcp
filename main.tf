terraform {
    required_version = ">= 0.12"
}

resource "google_compute_network" "network" {
  project                 = var.gcp_project
  name                    = var.gcp_network
  routing_mode            = var.routing_mode
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each                 = var.gcp_subnetworks
  project                  = var.gcp_project
  name                     = lookup(each.value, "name", null)
  region                   = lookup(each.value, "region", null)
  ip_cidr_range            = lookup(each.value, "ip_cidr_range", null)
  network                  = google_compute_network.network.self_link
  private_ip_google_access = true
}

resource "google_compute_address" "nat_ips" {
  count = var.total_nat_ips
  name = format("nat-ip-%s", count.index)
  project = var.gcp_project
  region = var.gcp_region
}

resource "google_compute_router" "router" {
  project = var.gcp_project
  region = var.gcp_region
  name = format("%s-router", var.gcp_network)
  network = google_compute_network.network.self_link
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "router-nat" {
  project = var.gcp_project
  name = format("%s-nat-gateway", var.gcp_network)
  router = google_compute_router.router.name
  region = var.gcp_region
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = google_compute_address.nat_ips.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }

  dynamic "subnetwork" {
    for_each = var.gcp_subnetworks
    content {
      name = lookup(each.value, "name", null)
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}