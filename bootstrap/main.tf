locals {
  environments = {
    for name, cfg in var.environments :
    name => merge(cfg, {
      state_key = coalesce(try(cfg.state_key, null), "${name}.terraform.tfstate")
      tags      = merge(var.default_tags, try(cfg.tags, {}))
    })
  }
}

resource "azurerm_resource_group" "env" {
  for_each = local.environments

  name     = each.value.resource_group_name
  location = each.value.location
  tags     = each.value.tags
}

resource "azurerm_storage_account" "state" {
  for_each = local.environments

  name                     = each.value.storage_account_name
  resource_group_name      = azurerm_resource_group.env[each.key].name
  location                 = azurerm_resource_group.env[each.key].location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = each.value.tags
}

resource "azurerm_storage_container" "state" {
  for_each = local.environments

  name                  = each.value.container_name
  storage_account_name  = azurerm_storage_account.state[each.key].name
  container_access_type = "private"
}

resource "azurerm_key_vault" "env" {
  for_each = local.environments

  name                       = each.value.key_vault_name
  resource_group_name        = azurerm_resource_group.env[each.key].name
  location                   = azurerm_resource_group.env[each.key].location
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true
  tags                       = each.value.tags
}

resource "azurerm_key_vault_access_policy" "terraform_sp" {
  for_each = local.environments

  key_vault_id = azurerm_key_vault.env[each.key].id
  tenant_id    = var.tenant_id
  object_id    = var.sp_object_id

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]
}
