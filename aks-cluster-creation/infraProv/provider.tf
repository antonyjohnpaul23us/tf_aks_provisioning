##- Terraform configuration & required providers -##
terraform {

### [Antony John Paul] - Backend storage of tf files (current state) is diabled to keep costs on my pvt subscription low
#   backend "azurerm" {
#     subscription_id      = "ssssssssssssssssss"
#     tenant_id            = "ttttttttttttttttttt"
#     resource_group_name      = "bb-tfstate-rg"
#     storage_account_name     = "bbtfstate"
#     #access_key               = ""  # Need to be udpated when creating resources in a subscription other than 'NextGen Platform US'
#     container_name           = "tfstate-dev"
#     key                      = "bb/aks-dev"
#   }
  required_version = ">= 0.13"
  required_providers {
    azuread = "0.11.0"
    azurerm = ">= 2.59.0"
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
provider "azurerm" {
   features {}
}