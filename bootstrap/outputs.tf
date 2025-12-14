output "remote_state_backends" {
  description = "Backend configuration for each environment."
  value = {
    for name, cfg in local.environments :
    name => {
      resource_group_name  = cfg.resource_group_name
      storage_account_name = cfg.storage_account_name
      container_name       = cfg.container_name
      key                  = cfg.state_key
    }
  }
}

output "key_vault_ids" {
  description = "Key Vault IDs per environment."
  value       = { for name, kv in azurerm_key_vault.env : name => kv.id }
}

output "key_vault_uris" {
  description = "Key Vault URIs per environment."
  value       = { for name, kv in azurerm_key_vault.env : name => kv.vault_uri }
}
