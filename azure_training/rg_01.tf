#this is a resource group and all objects for jump host
resource "azurerm_resource_group" "tf_rg_01" {
  name     = "tf_rg_01"
  location = "northeurope"
}

resource "azurerm_virtual_network" "tf_vn_01" {
  name                = "tf_vn_01"
  address_space       = ["10.100.0.0/16"]
  location            = azurerm_resource_group.tf_rg_01.location
  resource_group_name = azurerm_resource_group.tf_rg_01.name
}

resource "azurerm_subnet" "tf_vn_01_sn_01" {
  name                 = "tf_vn_01_sn_01"
  resource_group_name  = azurerm_resource_group.tf_rg_01.name
  virtual_network_name = azurerm_virtual_network.tf_vn_01.name
  address_prefixes     = ["10.100.0.0/24"]
}

resource "azurerm_network_interface" "tf_nic_01" {
  name                = "tf_nic_01"
  location            = azurerm_resource_group.tf_rg_01.location
  resource_group_name = azurerm_resource_group.tf_rg_01.name

  ip_configuration {
    name                          = "10.100.0.4"
    subnet_id                     = azurerm_subnet.tf_vn_01_sn_01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "tf-vm-01" {
  name                = "tf-vm-01"
  resource_group_name = azurerm_resource_group.tf_rg_01.name
  location            = azurerm_resource_group.tf_rg_01.location
  size                = "Standard_F2"
  admin_username      = "root"
  network_interface_ids = [
    azurerm_network_interface.tf_nic_01.id,
  ]

  admin_ssh_key {
    username   = "root"
    public_key = file("./files/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}