variable "resource_group_name_tfstate" {
  type        = string
  description = "Resource Group - tfstate"
}

variable "resource_group_location" {
  type        = string
  description = "centralindia"
}

variable "storage_account_name" {
  type        = string
  description = "Storage Account name for tfstate in Azure"
}

variable "storage_container_finprod_web_name" {
  type        = string
  description = "Storage Container name for finprod web in Azure"
}
variable "storage_container_ic_web_name" {
  type        = string
  description = "Storage Container name for IC web in Azure"
}
variable "storage_container_ic_app_name" {
  type        = string
  description = "Storage Container name for IC app in Azure"
}
variable "storage_container_finprod_app_name" {
  type        = string
  description = "Storage Container name for finprod app in Azure"
}
variable "storage_container_db_name" {
  type        = string
  description = "Storage Container name for DB in Azure"
}
variable "storage_container_misc_name" {
  type        = string
  description = "Storage Container name for MISC in Azure"
}

variable "storage_container_build_vm" {
  type        = string
  description = "Storage Container name for build VM in Azure"
}

variable "storage_container_test_vm" {
  type        = string
  description = "Storage Container name for test VM in Azure"
}