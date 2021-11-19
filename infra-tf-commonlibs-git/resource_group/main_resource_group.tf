resource "azurerm_resource_group" "modulebase" {
  location = var.location
  name     = var.name
  #tags     = "${merge(tomap({resourceName="azurerm_resource_group.modulebase"}), var.tf_workspace_tags, var.tf_module_tags)}"
  tags     = "${merge(tomap({resourceName="azurerm_resource_group.modulebase"}), var.tf_workspace_tags, var.tf_module_tags)}"

}
 