#this is a resource group and all objects for jump host
resource "azurerm_resource_group" "tf_rg_01" {
  name     = "tf_rg_01"
  location = "northeurope"
}

