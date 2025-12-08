output "policy_set_id" {
  value = azurerm_policy_set_definition.compute_initiative.id
}

output "policy_definition_ids" {
  value = {
    tags_required             = azurerm_policy_definition.tags_required.id
    allowed_regions           = azurerm_policy_definition.allowed_regions.id
    allowed_vm_skus           = azurerm_policy_definition.allowed_vm_skus.id
    managed_identity_required = azurerm_policy_definition.managed_identity_required.id
  }
}
