provider "azurerm" {
  version = "2.2.0"
  features{}
}
resource "azurerm_resource_group" "learning" {
  name = "learning"
  location = "westeu"
}
