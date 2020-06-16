provider "azurerm" {
  version         = "2.10.0"
  client_id       = "850e3cbc-1d00-4601-bbaa-9b88da7a3c07"
  client_secret   = "266eda55-e1b5-49ba-b32e-9abcdb91d4a1"
  subscription_id = "c1612ae2-5f15-487e-b926-fecaf634a54c"
  tenant_id       = "348fd517-5819-4a07-aec8-7e3090490c8b"
  features {}
}

# Create resource group
resource "azurerm_resource_group" "management_rg" {
  name     = var.rg
  location = var.location
}

# Create virtual network
resource "azurerm_virtual_network" "management_vnet" {
    name                = var.vnet
    address_space       = ["10.0.0.0/16"]
    location            = var.location
    resource_group_name = azurerm_resource_group.management_rg.name
}

# Create subnet
resource "azurerm_subnet" "management_subnet" {
    name                 = var.subnet
    resource_group_name  = azurerm_resource_group.management_rg.name
    virtual_network_name = azurerm_virtual_network.management_vnet.name
    address_prefixes       = ["10.0.1.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "rancher_ip" {
    name                         = var.rancherpublicip
    location                     = var.location
    resource_group_name          = azurerm_resource_group.management_rg.name
    allocation_method            = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "rancher_nsg" {
    name                = var.ranchernsg
    location            = var.location
    resource_group_name = azurerm_resource_group.management_rg.name
    security_rule {
        name                       = "Inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# Create network interface
resource "azurerm_network_interface" "rancher_nic" {
    name                      = var.ranchernic
    location                  = var.location
    resource_group_name       = azurerm_resource_group.management_rg.name
    ip_configuration {
        name                          = "ranchernicconfig"
        subnet_id                     = azurerm_subnet.management_subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.rancher_ip.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "rancher_asso" {
    network_interface_id      = azurerm_network_interface.rancher_nic.id
    network_security_group_id = azurerm_network_security_group.rancher_nsg.id
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "rancher_vm" {
    name                  = var.ranchervmname
    location              = var.location
    resource_group_name   = azurerm_resource_group.management_rg.name
    network_interface_ids = [azurerm_network_interface.rancher_nic.id]
    size                  = "Standard_B2s"
    os_disk {
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
    computer_name  = var.ranchervmname
    admin_username = "rancheradmin"
    admin_password = "Virgin123123"
}