provider "azurerm" {
  version = "2.10.0"
  features{}
}

resource "azurerm_resource_group" "rg" {
  name = var.vname
  location = var.vlocation
}

resource "azurerm_virtual_network" "vnet" {
  name = var.vname
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = [var.vaddressspace]
  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "subnet1" {
  name = "${var.vname}-subnet"
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name
  address_prefix = var.vsubnetprefix
}

resource "azurerm_network_interface" "vnic" {
  name                = "${var.vservername}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
