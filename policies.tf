module "policy" {
  source = "./modules/policy"

  default_effect    = var.default_effect
  allowed_locations = var.allowed_locations
  allowed_vm_skus   = var.allowed_vm_skus

  rg_id    = azurerm_resource_group.rg.id
  rg_name  = var.rg_name
  location = azurerm_resource_group.rg.location
}
