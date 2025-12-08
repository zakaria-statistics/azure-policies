output "resource_group_id" { value = azurerm_resource_group.rg.id }
output "resource_group_name" { value = azurerm_resource_group.rg.name }

output "vm_id" { value = azurerm_linux_virtual_machine.vm.id }
output "vm_public_ip" { value = azurerm_public_ip.pip.ip_address }
output "vm_principal_id" { value = azurerm_linux_virtual_machine.vm.identity[0].principal_id }

# Policy outputs (useful if another lab wants to reference them later)
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
