module "compute" {
  source = "./modules/compute"

  resource_group_name = azurerm_resource_group.rg.name
  resource_group_id   = azurerm_resource_group.rg.id
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  vm_name              = var.vm_name
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  admin_ssh_public_key = var.admin_ssh_public_key

  subnet_id = module.network.subnet_id
}
