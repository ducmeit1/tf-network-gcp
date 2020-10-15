terraform {
    required_version = ">= 0.12"
}

locals {
  region_subnets = {
    for subnet in var.gcp_subnetworks:
      subnet.region => subnet.name...
  }

  additional_region_subnets = {
    for subnet in var.additional_nat_subnetworks:
      subnet.region => subnet.name...
  }
}

resource "google_compute_network" "default" {
  project                         = var.gcp_project
  name                            = var.gcp_network
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = var.delete_default_routes_on_create
  description                     = var.description
  auto_create_subnetworks         = false
}

resource "google_compute_subnetwork" "default" {
  depends_on               = [google_compute_network.default]
  project                  = var.gcp_project
  for_each                 = {
    for subnet in var.gcp_subnetworks : "${subnet.name}.${subnet.region}.${subnet.ip_cidr_range}" => subnet
  }
  name                     = each.value.name
  region                   = each.value.region
  ip_cidr_range            = each.value.ip_cidr_range
  network                  = google_compute_network.default.self_link
  private_ip_google_access = true
}

resource "google_compute_router" "default" {
  depends_on  = [google_compute_network.default]
  project     = var.gcp_project
  for_each    = local.region_subnets
  name        = format("%s-%s-router", var.gcp_network, each.key)
  region      = each.key
  network     = google_compute_network.default.self_link
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "default" {
  depends_on                          = [google_compute_subnetwork.default, google_compute_router.default]
  project                             = var.gcp_project
  for_each                            = local.region_subnets
  name                                = format("%s-%s-nat-gw", var.gcp_network, each.key)
  router                              = format("%s-%s-router", var.gcp_network, each.key)
  region                              = each.key
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"

  log_config {
    enable = var.nat_logging
    filter = "ERRORS_ONLY"
  }

  dynamic "subnetwork" {
    for_each = [for s in each.value: {
      subnet = s
    }]

    content {
      name                    = subnetwork.value.subnet
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  dynamic "subnetwork" {
    for_each = [for r, s in local.additional_region_subnets: s if r == each.key ]

    content {
      name                    = subnetwork.value
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
}