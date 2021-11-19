resource "azurerm_virtual_network" "modulebase" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = "${merge(tomap({}), var.tf_workspace_tags, var.tf_module_tags)}"
}
