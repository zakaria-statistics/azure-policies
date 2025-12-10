output "resource_group_id" { value = azurerm_resource_group.rg.id }
output "resource_group_name" { value = azurerm_resource_group.rg.name }

output "vm_id" { value = module.compute.vm_id }
output "vm_public_ip" { value = module.compute.vm_public_ip }
output "vm_principal_id" { value = module.compute.vm_principal_id }

# Policy outputs (useful if another lab wants to reference them later)
output "policy_set_id" {
  value = module.policy.policy_set_id
}

output "policy_definition_ids" {
  value = module.policy.policy_definition_ids
}
