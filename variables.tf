# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "gcp_project" {
    description = "The name of the GCP Project where all resources will be launched."
    type        = string
}

variable "gcp_network" {
    description = "The name of the GCP Network where all resources will be linked."
    type        = string
}

variable "gcp_subnetworks" {
    description = "The list of the GCP Sub-networks where all resources will be linked."
    type        = set(object({
        name                = string
        region              = string
        ip_cidr_range       = string
    }))
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

variable "description" {
    description = "The description of the GCP Network."
    type        = string
    default     = ""
}

variable "routing_mode" {
    description = "The network-wide routing mode to use. Use REGIONAL or GLOBAL."
    type        = string
    default     = "GLOBAL"
}

variable "delete_default_routes_on_create" {
    description = "If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation."
    type        = bool
    default     = false
}