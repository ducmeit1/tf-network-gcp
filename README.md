# Provision GCP Network with Terraform

This is terraform module that will help you provision a VPC network on GCP with a subnet.

This module will:

- Create a private network on GCP.
- Create a sub-network for the private network on GCP.
- Create a Cloud-NAT to allows access over internet inside the private network.

## Usage

```hcl
provider "google" {
  region      = "asia-east1"
}

module "network" {
    source = "git::git@github.com:ducmeit1/tf-network-gcp.git/?ref=v0.0.1"
    gcp_project = "ducmeit1"
    gcp_region = "asia-east1"
    gcp_network_name = "shared-network-vpc"
    gcp_subnetwork_name = "shared-subnet"
}
```