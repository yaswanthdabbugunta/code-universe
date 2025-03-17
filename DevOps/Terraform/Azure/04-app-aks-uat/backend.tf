terraform {
  backend "azurerm" {
    resource_group_name  = "prd-uat-tfstate-rg"
    storage_account_name = "prduattfstate"
    container_name       = "finprod-uat-app-tfstate"
    key                  = "terraform.tfstate"
  }
}