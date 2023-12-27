resource "azurerm_ssh_public_key" "backend_public_key" {
  name                = "public_key"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  location            = azurerm_resource_group.myrg_deploy.location
  public_key          = file("~/.ssh/azure_rsa.pub")
}