resource "azurerm_resource_group" "rg_db" {
  name     = var.resource_group_name_db
  location = var.resource_group_location
}
resource "azurerm_mssql_server" "sql" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.rg_db.name
  location                     = azurerm_resource_group.rg_db.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  tags = {
    environment = "Dev" # Tag indicating it's for the development environment
  }
}

resource "azurerm_mssql_database" "db" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "Basic" # You can adjust this based on your DTU requirements
  zone_redundant = false
  tags = {
    environment = "Dev" # Tag indicating it's for the development environment
  }
}


resource "azurerm_mssql_firewall_rule" "sqlfirevall" {
  name             = "AllowMadhu"
  server_id        = azurerm_mssql_server.sql.id
  start_ip_address = "49.204.115.176"
  end_ip_address   = "49.204.115.176"
}
resource "azurerm_storage_account" "storage" {
  name                     = "tfstorage013"
  resource_group_name      = azurerm_resource_group.rg_db.name
  location                 = azurerm_resource_group.rg_db.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#resource "azurerm_mssql_database_extended_auditing_policy" "policy" {
#  database_id                             = azurerm_mssql_database.db.id
#  storage_endpoint                        = azurerm_storage_account.storage.primary_blob_endpoint
#  storage_account_access_key              = azurerm_storage_account.storage.primary_access_key
#  storage_account_access_key_is_secondary = false
#  retention_in_days                       = 1
#}