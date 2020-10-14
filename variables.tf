# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "gcp_project" {
    description = "The name of the GCP Project where all resources will be launched."
    type        = string
}

variable "gcp_region" {
    description = "The name of the GCP Region where all resources will be launched."
    type        = string
}

variable "gcp_network" {
    description = "The name of the GCP Network where all resources will be linked."
    type        = string
}

variable "gcp_subnetworks" {
    description = "The name of the GCP Sub-networks where all resources will be linked."
    type        = list(map(string))
}

variable "routing_mode" {
    description = "The network-wide routing mode to use. Use REGIONAL or GLOBAL."
    type        = string
    default     = "GLOBAL"
}

variable "total_nat_ips" {
    description = "The total number of nat IP address wil be created for Cloud-NAT."
    type        = number
    default     = 1
}