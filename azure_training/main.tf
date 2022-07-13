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

#resources used in many files
resource "tls_private_key" "tf_pk_01" {
  algorithm = "RSA"
  rsa_bits = 4096
}
output "tls_private_key" { 
    value = tls_private_key.tf_pk_01.private_key_pem 
    sensitive = true
}

#variables used in many files
variable vm_username {
  type        = string
  default     = "tf_user"
}