variable "default_effect" {
  description = "Default effect for policy definitions."
  type        = string
}

variable "allowed_locations" {
  description = "List of allowed regions."
  type        = list(string)
}

variable "allowed_vm_skus" {
  description = "List of allowed VM SKUs."
  type        = list(string)
}

variable "rg_id" {
  description = "ID of the resource group to assign the policy initiative."
  type        = string
}

variable "rg_name" {
  description = "Name of the resource group, used for names."
  type        = string
}

variable "location" {
  description = "Region where the assignment identity lives."
  type        = string
}
