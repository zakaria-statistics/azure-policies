########################
# Core
########################
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "client_id" {
  description = "Service principal client ID (appId)"
  type        = string
}

variable "client_secret" {
  description = "Service principal client secret (password)"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "location" {
  type        = string
  description = "Region for the lab. Policies may restrict allowed regions."
  default     = null
}

variable "rg_name" {
  type        = string
  description = "Compute Policy Lab RG name."
  default     = null
}

########################
# Tags (policy-driven)
########################
variable "environment" {
  type    = string
  default = "dev"
  validation {
    condition     = contains(keys(var.environment_configs), var.environment)
    error_message = "environment must exist in environment_configs (e.g., dev or prod)."
  }
}
variable "owner" {
  type    = string
  default = "compute-lab"
}
variable "cost_center" {
  type    = string
  default = "learning"
}

variable "environment_configs" {
  description = "Environment-specific overrides for core, network, and policy settings."
  type = map(object({
    rg_name           = string
    location          = string
    vm_name           = string
    vm_size           = string
    vnet_cidr         = string
    subnet_cidr       = string
    allowed_ssh_cidrs = list(string)
    allowed_locations = list(string)
    allowed_vm_skus   = list(string)
  }))

  default = {
    dev = {
      rg_name           = "rg-compute-dev"
      location          = "westeurope"
      vm_name           = "compute-lab-dev"
      vm_size           = "Standard_B2ms"
      vnet_cidr         = "10.60.0.0/16"
      subnet_cidr       = "10.60.1.0/24"
      allowed_ssh_cidrs = ["0.0.0.0/32"]
      allowed_locations = ["westeurope", "northeurope"]
      allowed_vm_skus   = ["Standard_B2ms", "Standard_B2s"]
    }

    prod = {
      rg_name           = "rg-compute-prod"
      location          = "northeurope"
      vm_name           = "compute-lab-prod"
      vm_size           = "Standard_D4s_v3"
      vnet_cidr         = "10.70.0.0/16"
      subnet_cidr       = "10.70.1.0/24"
      allowed_ssh_cidrs = ["0.0.0.0/32"]
      allowed_locations = ["northeurope"]
      allowed_vm_skus   = ["Standard_D4s_v3", "Standard_D2s_v5"]
    }
  }
}

########################
# Network
########################
variable "vnet_cidr" {
  type    = string
  default = null
}
variable "subnet_cidr" {
  type    = string
  default = null
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  default     = null
  description = "Restrict SSH sources."
}

########################
# Compute
########################
variable "vm_name" {
  type    = string
  default = null
}
variable "admin_username" {
  type    = string
  default = "azureadmin"
}
variable "admin_ssh_public_key" { type = string }

# This value will be checked by the allowed_vm_skus policy.
variable "vm_size" {
  type        = string
  default     = null
  description = "VM size for the lab. Policies may restrict allowed SKUs."
}

########################
# Policy knobs (learning)
########################
variable "default_effect" {
  type    = string
  default = "Deny"
  validation {
    condition     = contains(["Audit", "Deny", "Disabled"], var.default_effect)
    error_message = "default_effect must be Audit, Deny, or Disabled."
  }
}

variable "allowed_locations" {
  type    = list(string)
  default = null
}

variable "allowed_vm_skus" {
  type    = list(string)
  default = null
}
