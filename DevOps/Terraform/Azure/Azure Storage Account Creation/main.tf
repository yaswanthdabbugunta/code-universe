# Should be executed first time during setup
resource "azurerm_resource_group" "rg_tfstate" {
  name     = var.resource_group_name_tfstate
  location = var.resource_group_location
}
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_tfstate.name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}
resource "azurerm_storage_container" "container_misc" {
  name                  = var.storage_container_misc_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}
resource "azurerm_storage_container" "container_db" {
  name                  = var.storage_container_db_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}

resource "azurerm_storage_container" "container_finprod_web" {
  name                  = var.storage_container_finprod_web_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}

resource "azurerm_storage_container" "container_ic_web" {
  name                  = var.storage_container_ic_web_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}

resource "azurerm_storage_container" "container_ic_app" {
  name                  = var.storage_container_ic_app_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}
resource "azurerm_storage_container" "container_finprod_app" {
  name                  = var.storage_container_finprod_app_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}
resource "azurerm_storage_container" "container_build_vm" {
  name                  = var.storage_container_build_vm
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}
resource "azurerm_storage_container" "container_test_vm" {
  name                  = var.storage_container_test_vm
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}