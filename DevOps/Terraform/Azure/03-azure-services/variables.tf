
variable "resource_group_name_misc" {
  type        = string
  description = "Resource Group - Mis Services"
}

variable "resource_group_location" {
  type        = string
  description = "centralindia"
}

variable "storage_account_name" {
  type        = string
  description = "Storage Account name Application in Azure"
}

variable "app_configuration_name" {
  type        = string
  description = "App configuration name in Azure"
}
variable "redis_cache_name" {
  type        = string
  description = "Redis Cache name in Azure"
}
variable "keyvault_name" {
  type        = string
  description = "Keyvault name in Azure"
}
variable "eventhub_namespace_name" {
  type        = string
  description = "Eventhub namespace name in Azure"
}
variable "servicebus_namespace_name" {
  type        = string
  description = "Service bus namespace name in Azure"
}
