terraform {
    required_version = ">0.13"
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "3.85.0"
      }
    }
}

provider "azurerm" {
    features {
    }
    subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "myrg_deploy" {
    name = "myrg_deploy"
    location = "East US"
}

resource "azurerm_virtual_network" "vnet_demo" {

    name = "vnet_demo"
    resource_group_name = azurerm_resource_group.myrg_deploy.name
    location = azurerm_resource_group.myrg_deploy.location
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "private_subnet"
  resource_group_name  = azurerm_resource_group.myrg_deploy.name
  virtual_network_name = azurerm_virtual_network.vnet_demo.name
  address_prefixes     = ["10.0.1.0/24"]
}
  
resource "azurerm_subnet" "public_subnet" {
  name                 = "public_subnet"
  resource_group_name  = azurerm_resource_group.myrg_deploy.name
  virtual_network_name = azurerm_virtual_network.vnet_demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "frontend_public_ip" {
  name                = "frontend-public-ip"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location            = azurerm_resource_group.myrg_deploy.location
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "backend_public_ip" {
  name                = "backend-public-ip"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location            = azurerm_resource_group.myrg_deploy.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg_demo" {
    name="nsg_demo"
    location = azurerm_resource_group.myrg_deploy.location
    resource_group_name = azurerm_resource_group.myrg_deploy.name  
}

resource "azurerm_network_security_rule" "frontend_rule" {
  name                        = "AllowHTTP"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_demo.name
  resource_group_name         = azurerm_resource_group.myrg_deploy.name
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

resource "azurerm_network_security_rule" "db_rule" {
  name                        = "AllowMySQL"
  priority                    = 1003  
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_demo.name
  resource_group_name         = azurerm_resource_group.myrg_deploy.name
}


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

resource "azurerm_virtual_machine" "frontend_vm" {
  name                  = "FrontendVM"
  resource_group_name   = azurerm_resource_group.myrg_deploy.name
  location              = azurerm_resource_group.myrg_deploy.location
  network_interface_ids = [azurerm_network_interface.frontend_nic.id]

  vm_size     = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "FrontendOSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "FrontendVM"
    admin_username = "ahedbahri"
    admin_password = var.admin_password

  }

  os_profile_windows_config {
    provision_vm_agent = true
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

resource "azurerm_mysql_server" "mysqlserverdemo" {
  name                = "mysqlserverdemo2023"
  location            = azurerm_resource_group.myrg_deploy.location
  resource_group_name = azurerm_resource_group.myrg_deploy.name

  administrator_login          = "mysqladmin"
  administrator_login_password = var.mysql_admin_password

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mydb" {
  name                = "mydb"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  server_name         = azurerm_mysql_server.mysqlserverdemo.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"

  lifecycle {
    prevent_destroy = true
  }
  
  depends_on = [
    azurerm_virtual_machine.frontend_vm,
    azurerm_virtual_machine.backend_vm,
  ]
}
