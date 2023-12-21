output "frontend_public_ip_address" {
  value = azurerm_linux_virtual_machine.frontend_VM.public_ip_address
}

output "backend_public_ip_address" {
  value = azurerm_linux_virtual_machine.backend_VM.public_ip_address
}
