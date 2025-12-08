module "network" {
  source = "./modules/network"

  name_prefix         = var.rg_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  vnet_cidr         = var.vnet_cidr
  subnet_cidr       = var.subnet_cidr
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}
