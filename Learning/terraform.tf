terraform {
  backend "azurerm" {
    resource_group_name  = "demo"
    storage_account_name = "demoforsushil"
    container_name       = "demo-tfstate"
    key                  = "demo.terraform.tfstate"
  }
}
