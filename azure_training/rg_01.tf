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

resource "azurerm_public_ip" "tf_pi_01" {
  name                = "tf_pi_01"
  resource_group_name = azurerm_resource_group.tf_rg_01.name
  location            = azurerm_resource_group.tf_rg_01.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "tf_nic_01" {
  name                = "tf_nic_01"
  location            = azurerm_resource_group.tf_rg_01.location
  resource_group_name = azurerm_resource_group.tf_rg_01.name

  ip_configuration {
    name                          = "10.100.0.4"
    subnet_id                     = azurerm_subnet.tf_vn_01_sn_01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.tf_pi_01.id

  }
}

resource "azurerm_linux_virtual_machine" "tf-vm-01" {
  name                = "tf-vm-01"
  resource_group_name = azurerm_resource_group.tf_rg_01.name
  location            = azurerm_resource_group.tf_rg_01.location
  size                = "Standard_F2"
  admin_username      = var.vm_username
  network_interface_ids = [
    azurerm_network_interface.tf_nic_01.id,
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

provisioner "file" {
    source      = "files/id_rsa.pub"
    destination = "/home/${var.vm_username}/.ssh/id_rsa_${var.vm_username}.pub"
    connection {
      type = "ssh"
      user = var.vm_username
      host = azurerm_public_ip.tf_pi_01.ip_address
      port = "22"
      agent = false
      private_key = tls_private_key.tf_pk_01.private_key_pem
    } 
  }

provisioner "file" {
    content      = "${tls_private_key.tf_pk_01.private_key_pem}"
    destination = "/home/${var.vm_username}/.ssh/id_rsa"
    connection {
      type = "ssh"
      user = var.vm_username
      host = azurerm_public_ip.tf_pi_01.ip_address
      port = "22"
      agent = false
      private_key = tls_private_key.tf_pk_01.private_key_pem
    } 
  }

  provisioner "remote-exec" {
    inline = [
      "cat /home/${var.vm_username}/.ssh/id_rsa_${var.vm_username}.pub >> /home/${var.vm_username}/.ssh/authorized_keys",
      "chmod 600 /home/${var.vm_username}/.ssh/id_rsa"
    ]
    connection {
      type = "ssh"
      user = var.vm_username
      host = azurerm_public_ip.tf_pi_01.ip_address
      port = "22"
      agent = false
      private_key = tls_private_key.tf_pk_01.private_key_pem
    } 
  }
}