resource "azurerm_public_ip" "backend_public_ip" {
  name                = "backend-public-ip"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location            = azurerm_resource_group.myrg_deploy.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_rule" "backend_rule" {
  name                        = "AllowBackend"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_demo.name
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


resource "azurerm_virtual_machine" "backend_vm" {
  name                  = "BackendVM"
  resource_group_name   = azurerm_resource_group.myrg_deploy.name
  location              = azurerm_resource_group.myrg_deploy.location
  network_interface_ids = [azurerm_network_interface.backend_nic.id]

  vm_size     = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "BackendOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "BackendVM"
    admin_username = "ahedbahri"
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }
}
