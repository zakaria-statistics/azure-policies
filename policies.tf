module "policy" {
  source = "./modules/policy"

  default_effect    = var.default_effect
  allowed_locations = local.resolved.allowed_locations
  allowed_vm_skus   = local.resolved.allowed_vm_skus

  rg_id    = azurerm_resource_group.rg.id
  rg_name  = local.resolved.rg_name
  location = azurerm_resource_group.rg.location
}
