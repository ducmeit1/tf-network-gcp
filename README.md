# Provision GCP Network with Terraform

This is terraform module that will help you provision a VPC network on GCP with multiple subnets & cloud-nats.

This module will:

- Create a private network on GCP.
- Create one or multiple sub-networks for the private network on GCP.
- Create one or multiple Cloud-NATs to allows access over internet inside the private network.

## Usage

### Input

```hcl
module "network" {
    source            = "github.com/ducmeit1/tf-network-gcp"
    gcp_project       = "ducmeit1"
    gcp_network       = "global-network"
    gcp_subnetworks=[
    {
        name          = "dc1-subnet"
        region        = "asia-east1"
        ip_cidr_range = "10.127.0.0/20" 
    },
    {
        name          = "dc2-subnet"
        region        = "asia-southeast1"
        ip_cidr_range = "10.128.0.0/20" 
    },
    ]
}
```

```shell
terraform plan
terraform apply --auto-approve
```

### Output

Example:

```hcl
network = {
  "gateway_ipv4" = ""
  "name" = "global-network"
  "routing_mode" = "GLOBAL"
  "self_link" = "https://www.googleapis.com/compute/v1/projects/ducmeit1/global/networks/global-network"
}
router = [
  {
    "name" = "global-network-asia-east1-router"
    "region" = "asia-east1"
    "self_link" = "https://www.googleapis.com/compute/v1/projects/ducmeit1/regions/asia-east1/routers/global-network-asia-east1-router"
  },
  {
    "name" = "global-network-asia-southeast1-router"
    "region" = "asia-southeast1"
    "self_link" = "https://www.googleapis.com/compute/v1/projects/ducmeit1/regions/asia-southeast1/routers/global-network-asia-southeast1-router"
  },
]
subnetwork = [
  {
    "gateway_address" = "10.127.0.1"
    "ip_cidr_range" = "10.127.0.0/20"
    "name" = "dc1-subnet"
    "self_link" = "https://www.googleapis.com/compute/v1/projects/ducmeit1/regions/asia-east1/subnetworks/dc1-subnet"
  },
  {
    "gateway_address" = "10.128.0.1"
    "ip_cidr_range" = "10.128.0.0/20"
    "name" = "dc2-subnet"
    "self_link" = "https://www.googleapis.com/compute/v1/projects/ducmeit1/regions/asia-southeast1/subnetworks/dc2-subnet"
  },
]
```
