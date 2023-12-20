
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

resource "azurerm_mysql_server" "mysqlserverdemo" {
  name                = "mysqlserverdemo2023"
  location            = azurerm_resource_group.myrg_deploy.location
  resource_group_name = azurerm_resource_group.myrg_deploy.name

  administrator_login          = "mysqladmin"
  administrator_login_password = var.mysql_admin_password

  sku_name   = "GP_Gen5_2"
  storage_mb = 1024
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