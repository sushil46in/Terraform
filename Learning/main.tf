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

resource "azurerm_network_interface" "server_nic" {
  name                = "${var.server_name}-${format("%02d", count.index)}-nic"
  location            = var.server_location
  resource_group_name = azurerm_resource_group.server_rg.name
  count               = var.server_count

  ip_configuration {
    name                          = "${var.server_name}-ip"
    subnet_id                     = azurerm_subnet.server_subnet.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_security_group" "server_nsg" {
  name                = "${var.server_resource_prefix}-nsg"
  location            = var.server_location
  resource_group_name = azurerm_resource_group.server_rg.name
}

resource "azurerm_network_security_rule" "server_nsg_rule_ssh" {
  name                        = "Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.server_rg.name
  network_security_group_name = azurerm_network_security_group.server_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "server_sag" {
  network_security_group_id = azurerm_network_security_group.server_nsg.id
  subnet_id                 = azurerm_subnet.server_subnet.id
}
resource "azurerm_public_ip" "publicip" {
  name                         = "acceptanceTestPublicIp1"
  location                     = "${azurestack_resource_group.test.location}"
  resource_group_name          = "${azurestack_resource_group.test.name}"
  public_ip_address_allocation = "static"

  tags {
    environment = "Production"
  }
}
resource "azurerm_virtual_machine" "dockervm" {
  name = "${var.server_name}-${format("%02d", count.index)}"
  location= var.location
  resource_group_name = azurerm_resource_group.server_rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = azurerm_virtual_machine.dockervm.name
    admin_username = "sushil"
    admin_password = "Virgin123123"
  }

}






resource "azurerm_availability_set" "server_availability_set" {
  name                        = "${var.server_resource_prefix}-availability-set"
  location                    = var.server_location
  resource_group_name         = azurerm_resource_group.server_rg.name
  managed                     = true
  platform_fault_domain_count = 2
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.aks_rg
  location = var.aks_location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.aks_name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}