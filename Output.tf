output "public_ip_address" {
  value = azurerm_linux_virtual_machine.frontend_VM.public_ip_address
}