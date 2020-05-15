provider "azurerm" {
  version = "2.10.0"
  features{}
}

resource "azurerm_resource_group" "rg" {
  name = var.vname
  location = "westeurope"
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vname
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["10.0.0.0/16"]
}
