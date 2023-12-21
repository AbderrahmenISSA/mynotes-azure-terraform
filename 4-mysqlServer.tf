resource "azurerm_network_security_rule" "mysql_rule" {
  name                        = "AllowMySQL"
  priority                    = 1003  
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3306"
  source_address_prefix       = "*"
  # source_address_prefix       = "137.117.213.55"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg_back.name
  resource_group_name         = azurerm_resource_group.myrg_deploy.name
}

resource "azurerm_mysql_server" "mynote-sql-server" {
  name                = "mynote-sql-server"
  location            = azurerm_resource_group.myrg_deploy.location
  resource_group_name = azurerm_resource_group.myrg_deploy.name

  administrator_login          = var.mysql_admin_login
  administrator_login_password = var.mysql_admin_password

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120 #Error: expected storage_mb to be in the range (5120 - 16777216), got 1024
  version    = "8.0"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = true
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "notes-db" {
  name                = "notes-db"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  server_name         = azurerm_mysql_server.mynote-sql-server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
  
}