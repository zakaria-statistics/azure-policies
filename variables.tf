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
}

variable "rg_name" {
  type        = string
  description = "Compute Policy Lab RG name."
}

########################
# Tags (policy-driven)
########################
variable "environment" {
  type    = string
  default = "lab"
}
variable "owner" {
  type    = string
  default = "compute-lab"
}
variable "cost_center" {
  type    = string
  default = "learning"
}

########################
# Network
########################
variable "vnet_cidr" {
  type    = string
  default = "10.60.0.0/16"
}
variable "subnet_cidr" {
  type    = string
  default = "10.60.1.0/24"
}

variable "allowed_ssh_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/32"]
  description = "Restrict SSH sources."
}

########################
# Compute
########################
variable "vm_name" {
  type    = string
  default = "compute-lab-vm"
}
variable "admin_username" {
  type    = string
  default = "azureadmin"
}
variable "admin_ssh_public_key" { type = string }

# This value will be checked by the allowed_vm_skus policy.
variable "vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "VM size for the lab. Policies may restrict allowed SKUs."
}

########################
# Policy knobs (learning)
########################
variable "default_effect" {
  type    = string
  default = "Audit"
  validation {
    condition     = contains(["Audit", "Deny", "Disabled"], var.default_effect)
    error_message = "default_effect must be Audit, Deny, or Disabled."
  }
}

variable "allowed_locations" {
  type    = list(string)
  default = ["westeurope", "northeurope"]
}

variable "allowed_vm_skus" {
  type = list(string)
  default = [
    "Standard_B1s",
    "Standard_B2s",
    "Standard_B2ms"
  ]
}
