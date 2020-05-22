provider "azurerm" {
  version         = "2.10.0"
  client_id       = "850e3cbc-1d00-4601-bbaa-9b88da7a3c07"
  client_secret   = "266eda55-e1b5-49ba-b32e-9abcdb91d4a1"
  subscription_id = "c1612ae2-5f15-487e-b926-fecaf634a54c"
  tenant_id       = "348fd517-5819-4a07-aec8-7e3090490c8b"
  features {}
}

resource "azurerm_resource_group" "server_rg" {
  name     = var.server_rg
  location = var.server_location
}

resource "azurerm_virtual_network" "server_vnet" {
  name                = "${var.server_resource_prefix}-vnet"
  location            = var.server_location
  resource_group_name = azurerm_resource_group.server_rg.name
  address_space       = [var.server_address_space]
}

resource "azurerm_subnet" "server_subnet" {
  name                 = "${var.server_resource_prefix}-subnet"
  resource_group_name  = azurerm_resource_group.server_rg.name
  virtual_network_name = azurerm_virtual_network.server_vnet.name
  address_prefixes     = [var.server_subnet]
}

