terraform {
  backend "azurerm" {
    resource_group_name  = "terraform"
    storage_account_name = "terraformtfsa"
    container_name       = "terraformcontainer"
    key                  = "demo.terraform.tfstate"
  }
}
