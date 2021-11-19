provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      #version = "~> 2.46.0"
      version = ">= 2.59.0"
    }
  }
}
