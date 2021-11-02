#this is a resource group and all objects for jump host
resource "azurerm_resource_group" "tf_rg_02" {
  name     = "tf_rg_02"
  location = "northeurope"
}

resource "azurerm_virtual_network" "tf_vn_02" {
  name                = "tf_vn_02"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tf_rg_02.location
  resource_group_name = azurerm_resource_group.tf_rg_02.name
}

resource "azurerm_subnet" "tf_vn_02_sn_01" {
  name                 = "tf_vn_02_sn_01"
  resource_group_name  = azurerm_resource_group.tf_rg_02.name
  virtual_network_name = azurerm_virtual_network.tf_vn_02.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_public_ip" "tf_pi_02" {
  name                = "tf_pi_02"
  resource_group_name = azurerm_resource_group.tf_rg_02.name
  location            = azurerm_resource_group.tf_rg_02.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "tf_nic_02" {
  name                = "tf_nic_02"
  location            = azurerm_resource_group.tf_rg_02.location
  resource_group_name = azurerm_resource_group.tf_rg_02.name

  ip_configuration {
    name                          = "10.0.0.4"
    subnet_id                     = azurerm_subnet.tf_vn_02_sn_01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf_pi_02.id

  }
}

resource "azurerm_linux_virtual_machine" "tf-vm-02" {
  name                = "tf-vm-02"
  resource_group_name = azurerm_resource_group.tf_rg_02.name
  location            = azurerm_resource_group.tf_rg_02.location
  size                = "Standard_F2"
  admin_username      = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.tf_nic_02.id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = tls_private_key.tf_pk_01.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}