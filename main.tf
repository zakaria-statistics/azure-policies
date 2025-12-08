# Centralized tags to satisfy the tag policy easily.
locals {
  tags = {
    environment = var.environment
    owner       = var.owner
    cost_center = var.cost_center
    lab         = "compute-policy"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = local.tags
}
