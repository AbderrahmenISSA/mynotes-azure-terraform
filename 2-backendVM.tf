resource "azurerm_public_ip" "backend_public_ip" {
  name                = "backend-public-ip"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location            = azurerm_resource_group.myrg_deploy.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_rule" "backend_rule" {
  name                        = "AllowBackend"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_back.name
  resource_group_name         = azurerm_resource_group.myrg_deploy.name
}

resource "azurerm_network_security_rule" "backend_ssh_rule" {
  name                        = "AllowSSH"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.SSH_PUBLIC_IP
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_back.name
  resource_group_name         = azurerm_resource_group.myrg_deploy.name
}

resource "azurerm_network_interface" "backend_nic" {
  name                = "BackendNIC"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location = azurerm_resource_group.myrg_deploy.location

  ip_configuration {
    name                          = "BackendNICConfig"
    subnet_id                     = azurerm_subnet.private_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.backend_public_ip.id

  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "backend_association" {
  network_interface_id      = azurerm_network_interface.backend_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_back.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "backend_VM" {
  name                  = "BackendVM"
  location              = azurerm_resource_group.myrg_deploy.location
  resource_group_name   = azurerm_resource_group.myrg_deploy.name
  network_interface_ids = [azurerm_network_interface.backend_nic.id]
  size                  = var.BACKEND_VM_SIZE

  os_disk {
    name                 = var.BACKEND_VM_OS_DISK
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "backend"
  admin_username = var.SSH_USER

  admin_ssh_key {
    username   = var.SSH_USER
    public_key = azurerm_ssh_public_key.backend_public_key.public_key
  }

  # Run the bash script
  custom_data = base64encode(file("scripts/backendScript.sh"))

}
