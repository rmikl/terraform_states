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
}

resource "azurerm_resource_group" "example" {
  name     = "production-resources-tf"
  location = "northeurope"
}

resource "azurerm_resource_group" "example2" {
  name     = "production-resources-tf2"
  location = "northeurope"
}