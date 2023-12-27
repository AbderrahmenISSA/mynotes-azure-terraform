resource "azurerm_mysql_server" "mynote-sql-server" {
  name                = "mynote-sqlserver"
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
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "notes-db" {
  name                = "notes-db"
  resource_group_name = azurerm_resource_group.myrg_deploy.name
  server_name         = azurerm_mysql_server.mynote-sql-server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_0900_ai_ci"
}