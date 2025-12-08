variable "resource_group_name" {
  description = "Resource group hosting the compute resources."
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID for role assignments."
  type        = string
}

variable "location" {
  description = "Azure region for compute resources."
  type        = string
}

variable "tags" {
  description = "Common tags to apply to compute resources."
  type        = map(string)
}

variable "vm_name" {
  description = "Name of the VM."
  type        = string
}

variable "vm_size" {
  description = "Size/SKU for the VM."
  type        = string
}

variable "admin_username" {
  description = "Admin username."
  type        = string
}

variable "admin_ssh_public_key" {
  description = "Admin SSH public key."
  type        = string
}

variable "subnet_id" {
  description = "Subnet for the NIC."
  type        = string
}
