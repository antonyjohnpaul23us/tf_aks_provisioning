##-- DATA SOURCES --##

## Resource group that AKS will be deployed to
data "azurerm_resource_group" "cluster" {
  name = var.resource_group
}
## Fetching the current verson of AKS
data "azurerm_kubernetes_service_versions" "current" {
  location        = data.azurerm_resource_group.cluster.location
  version_prefix  = var.kubernetes_version_prefix
  include_preview = var.kubernetes_include_preview
}