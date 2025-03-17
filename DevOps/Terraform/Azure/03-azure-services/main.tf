data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_misc" {
  name     = var.resource_group_name_misc
  location = var.resource_group_location
}
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg_misc.name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_configuration" "appconf" {
  name                = var.app_configuration_name
  resource_group_name = azurerm_resource_group.rg_misc.name
  location            = azurerm_resource_group.rg_misc.location
}
resource "azurerm_role_assignment" "appconf_dataowner" {
  scope                = azurerm_app_configuration.appconf.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_redis_cache" "azrediscache" {
  name                = var.redis_cache_name
  location            = azurerm_resource_group.rg_misc.location
  resource_group_name = azurerm_resource_group.rg_misc.name
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
  }
}
resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  location                    = azurerm_resource_group.rg_misc.location
  resource_group_name         = azurerm_resource_group.rg_misc.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
resource "azurerm_eventhub_namespace" "ehnamespace" {
  name                = var.eventhub_namespace_name
  location            = azurerm_resource_group.rg_misc.location
  resource_group_name = azurerm_resource_group.rg_misc.name
  sku                 = "Standard"
  capacity            = 1

}

resource "azurerm_servicebus_namespace" "servicebus" {
  name                = var.servicebus_namespace_name
  location            = azurerm_resource_group.rg_misc.location
  resource_group_name = azurerm_resource_group.rg_misc.name
  sku                 = "Standard"
}

