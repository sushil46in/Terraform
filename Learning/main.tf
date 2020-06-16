provider "azurerm" {
  version         = "2.10.0"
  client_id       = "850e3cbc-1d00-4601-bbaa-9b88da7a3c07"
  client_secret   = "266eda55-e1b5-49ba-b32e-9abcdb91d4a1"
  subscription_id = "c1612ae2-5f15-487e-b926-fecaf634a54c"
  tenant_id       = "348fd517-5819-4a07-aec8-7e3090490c8b"
  features {}
}

resource "azurerm_resource_group" "rancher_rg" {
  name     = var.rg
  location = var.location
}

