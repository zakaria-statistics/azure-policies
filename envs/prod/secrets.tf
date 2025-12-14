data "azurerm_key_vault" "secrets" {
  provider            = azurerm.bootstrap
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

data "azurerm_key_vault_secret" "terraform_client_secret" {
  provider     = azurerm.bootstrap
  name         = var.client_secret_secret_name
  key_vault_id = data.azurerm_key_vault.secrets.id
}

data "azurerm_key_vault_secret" "admin_ssh_public_key" {
  provider     = azurerm.bootstrap
  count        = var.admin_ssh_public_key_secret_name == "" ? 0 : 1
  name         = var.admin_ssh_public_key_secret_name
  key_vault_id = data.azurerm_key_vault.secrets.id
}

locals {
  terraform_client_secret = coalesce(
    var.client_secret,
    data.azurerm_key_vault_secret.terraform_client_secret.value
  )

  admin_ssh_public_key = coalesce(
    var.admin_ssh_public_key,
    try(data.azurerm_key_vault_secret.admin_ssh_public_key[0].value, null)
  )
}
