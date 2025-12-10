# Centralized tags to satisfy the tag policy easily.
locals {
  env_defaults = var.environment_configs[var.environment]

  # Merge explicit variable overrides with environment defaults.
  resolved = {
    rg_name           = coalesce(var.rg_name, local.env_defaults.rg_name)
    location          = coalesce(var.location, local.env_defaults.location)
    vm_name           = coalesce(var.vm_name, local.env_defaults.vm_name)
    vm_size           = coalesce(var.vm_size, local.env_defaults.vm_size)
    vnet_cidr         = coalesce(var.vnet_cidr, local.env_defaults.vnet_cidr)
    subnet_cidr       = coalesce(var.subnet_cidr, local.env_defaults.subnet_cidr)
    allowed_ssh_cidrs = coalesce(var.allowed_ssh_cidrs, local.env_defaults.allowed_ssh_cidrs)
    allowed_locations = coalesce(var.allowed_locations, local.env_defaults.allowed_locations)
    allowed_vm_skus   = coalesce(var.allowed_vm_skus, local.env_defaults.allowed_vm_skus)
  }

  tags = {
    environment = var.environment
    owner       = var.owner
    cost_center = var.cost_center
    lab         = "compute-policy"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.resolved.rg_name
  location = local.resolved.location
  tags     = local.tags
}
