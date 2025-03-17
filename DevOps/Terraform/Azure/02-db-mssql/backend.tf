terraform {
  backend "azurerm" {
    resource_group_name  = "prd-tfstate-rg"
    storage_account_name = "prddevtfstate"
    container_name       = "db-tfstate"
    key                  = "terraform.tfstate"
  }
}