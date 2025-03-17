resource "azurerm_resource_group" "rg_uat_app" {
  name     = var.resource_group_name_app
  location = var.resource_group_location
}
resource "azurerm_virtual_network" "aks_uat_vnet" {
  name                = "aks-vnet"
  address_space       = ["10.2.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg_uat_app.name
}

resource "azurerm_subnet" "aks_uat_subnet" {
  name                 = "aks-uat-subnet"
  resource_group_name  = azurerm_resource_group.rg_uat_app.name
  virtual_network_name = azurerm_virtual_network.aks_uat_vnet.name
  address_prefixes     = ["10.2.1.0/24"]
}

resource "azurerm_network_security_group" "aks_uat_nsg" {
  name                = "aks-uat-nsg"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg_uat_app.name
}

resource "azurerm_subnet_network_security_group_association" "aks_uat_nsg_association" {
  subnet_id                 = azurerm_subnet.aks_uat_subnet.id
  network_security_group_id = azurerm_network_security_group.aks_uat_nsg.id
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg_uat_app.name
  dns_prefix          = var.cluster_name
  

  default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_D2as_v4"
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

}