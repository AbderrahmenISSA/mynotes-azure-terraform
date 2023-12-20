resource "azurerm_virtual_network" "vnet_demo" {
    name = "VNET_${var.APP_NAME}"
    resource_group_name = azurerm_resource_group.myrg_deploy.name
    location = azurerm_resource_group.myrg_deploy.location
    address_space = var.VNET_CIDR
}

resource "azurerm_subnet" "private_subnet" {
  name                 = "private_subnet"
  resource_group_name  = azurerm_resource_group.myrg_deploy.name
  virtual_network_name = azurerm_virtual_network.vnet_demo.name
  address_prefixes     = var.PRIVATE_SUBNETS_CIDR
}
  
resource "azurerm_subnet" "public_subnet" {
  name                 = "public_subnet"
  resource_group_name  = azurerm_resource_group.myrg_deploy.name
  virtual_network_name = azurerm_virtual_network.vnet_demo.name
  address_prefixes     = var.PUBLIC_SUBNETS_CIDR
}

resource "azurerm_network_security_group" "nsg_demo" {
    name = "NSG_${var.APP_NAME}"
    location = azurerm_resource_group.myrg_deploy.location
    resource_group_name = azurerm_resource_group.myrg_deploy.name  
}
