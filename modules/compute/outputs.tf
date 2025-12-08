output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "vm_public_ip" {
  value = azurerm_public_ip.pip.ip_address
}

output "vm_principal_id" {
  value = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

output "network_interface_id" {
  value = azurerm_network_interface.nic.id
}

output "public_ip_id" {
  value = azurerm_public_ip.pip.id
}
