resource "azurerm_public_ip" "frontend_public_ip" {
  name                = "frontend-public-ip"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location            = azurerm_resource_group.myrg_deploy.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_rule" "frontend_http_rule" {
  name                        = "AllowHTTP"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_front.name
  resource_group_name         = azurerm_resource_group.myrg_deploy.name
}

resource "azurerm_network_security_rule" "frontend_ssh_rule" {
  name                        = "AllowSSH"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.SSH_PUBLIC_IP
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_front.name
  resource_group_name         = azurerm_resource_group.myrg_deploy.name
}

# Create network interface
resource "azurerm_network_interface" "frontend_nic" {
  name                = "FrontendNIC"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location = azurerm_resource_group.myrg_deploy.location

  ip_configuration {
    name                          = "FrontendNICConfig"
    subnet_id                     = azurerm_subnet.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.frontend_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "frontend_association" {
  network_interface_id      = azurerm_network_interface.frontend_nic.id
  network_security_group_id = azurerm_network_security_group.nsg_front.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "frontend_VM" {
  name                  = "FrontendVM"
  location              = azurerm_resource_group.myrg_deploy.location
  resource_group_name   = azurerm_resource_group.myrg_deploy.name
  network_interface_ids = [azurerm_network_interface.frontend_nic.id]
  size                  = var.FRONTEND_VM_SIZE

  os_disk {
    name                 =  var.FRONTEND_VM_OS_DISK
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "frontend"
  admin_username = var.SSH_USER

  admin_ssh_key {
    username   = var.SSH_USER
    public_key = azurerm_ssh_public_key.backend_public_key.public_key
  }

  # install docker package
  # custom_data = base64encode(file("scripts/frontendScript.sh"))
  
}
