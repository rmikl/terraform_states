terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "44ddbd0f-22a4-4dd1-9c1c-c72e61a3fb69"
  tenant_id       = "cf17c4a9-7128-4bf9-ad02-8f9114ecaf5c"
}


resource "azurerm_resource_group" "example" {
  name     = "production-resources-tf"
  location = "northeurope"
}