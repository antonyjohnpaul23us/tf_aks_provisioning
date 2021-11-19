######################
##-- Local Values --##
######################
locals {
  additional_node_pools = flatten([
    for np in var.additional_node_pools : {
      name                = np.name
      vm_size             = np.vm_size
      node_count          = np.node_count
      enable_auto_scaling = np.enable_auto_scaling
      min_count           = np.min_count
      max_count           = np.max_count
      node_labels         = np.node_labels
      node_taints         = np.node_taints
      tags                = np.tags
    }
  ])
  # var.kubernetes_version defaults to unknown if there is no value input
  # and if that is the case, we will use the data source to determinate the
  # latest version of kubernetes
  kubernetes_version = var.kubernetes_version == "unknown" ? data.azurerm_kubernetes_service_versions.current.latest_version : var.kubernetes_version
}