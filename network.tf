module "network" {
  source = "./modules/network"

  name_prefix         = local.resolved.rg_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = local.tags

  vnet_cidr         = local.resolved.vnet_cidr
  subnet_cidr       = local.resolved.subnet_cidr
  allowed_ssh_cidrs = local.resolved.allowed_ssh_cidrs
}
