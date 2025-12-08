variable "name_prefix" {
  description = "Base name used to build network resource names."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group hosting the network resources."
  type        = string
}

variable "location" {
  description = "Azure region for network resources."
  type        = string
}

variable "tags" {
  description = "Common tags to apply to network resources."
  type        = map(string)
}

variable "vnet_cidr" {
  description = "CIDR for the virtual network."
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR for the subnet."
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "Allowed CIDR blocks for SSH."
  type        = list(string)
}
