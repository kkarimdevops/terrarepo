resource "random_password" "mainvm" {
  length = "16"
}

resource "azurerm_resource_group" "main" {
  name = "rg-app-dev-test-iac-POC"
  location = "West Europe"

  tags = {
    IAC = "Mundipharma IT Services Limited"
    "Support Group" = "na"
    }
}

resource "azurerm_virtual_network" "testvnet1" {
  name = "testvnet1"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  address_space = [ "10.0.0.0/16"]
}

resource "azurerm_subnet" "name" {
  name = "testsubnet1"
  resource_group_name = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.testvnet1.name
  address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_network_interface" "nic1" {
  name = "testvm01nic1"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  ip_configuration {
    name = "ip1"
    subnet_id = azurerm_subnet.name.id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_windows_virtual_machine" "test-res" {
  name = "testvm01"
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  size = "Standard_B2ms"
  admin_username = "admin01"
  admin_password = random_password.mainvm.result
  network_interface_ids = [ azurerm_network_interface.nic1.id ]

  os_disk {
    storage_account_type = "Standard_LRS"
    caching = "ReadWrite"
  }

  source_image_reference {
    publisher = "microsoftwindowsserver"
    offer = "windowsserver"
    sku = "2022-datacenter-azure-edition"
    version = "latest"
  }

}