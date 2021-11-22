##################################
##-- AZURE KUBERNETES SERVICE --##
##################################
#### --- Git Source Repo --- https://github.com/innovationnorway/terraform-azurerm-kubernetes-cluster/blob/master/aks.tf
##- AKS cluster -##
resource "azurerm_kubernetes_cluster" "cluster" {
  # Set name, location, resource group and dns prefix
  name                = format("%s%s", var.cluster_prefix, var.name)
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = var.name

  # If kubernetes version is specified, we will attempt to use that
  # If not specified, use the latest non-preview version available in AKS
  # See the local value for more details
  kubernetes_version = local.kubernetes_version

  # Enable kube_dashboard, Azure Policy, Managed Service Identity and the OMS agent
  # Set to use the log analytics workspace in West Europe, will be updated to use
  # data from a logging workspace in Terraform Cloud
  addon_profile {
    # kube_dashboard {
    #   enabled = true
    # }
    azure_policy {
      enabled = var.enable_azure_policy
    }
    oms_agent {
      enabled                    = var.oms_agent_enabled #false #true
      #log_analytics_workspace_id = var.log_analytics
    }
  }
  # Using default Network Profile - kubenet
  # network_profile {
  #   network_plugin     = "azure"
  #   service_cidr       = "10.10.0.0/16"
  #   dns_service_ip     = "10.10.0.10"
  #   docker_bridge_cidr = "172.17.0.1/16"
  #   network_policy     = var.network_policy
  # }
  role_based_access_control {
    enabled = var.role_based_access_control
    azure_active_directory {
      managed                = true
      admin_group_object_ids = var.admin_groups
    }
  }

  enable_pod_security_policy = var.enable_pod_security_policy
  default_node_pool {
    name           = var.default_node_pool[0].name
    #vnet_subnet_id = var.subnet_id
    vm_size        = var.default_node_pool[0].vm_size
    node_count     = var.default_node_pool[0].node_count

    enable_auto_scaling = var.default_node_pool[0].enable_auto_scaling
    min_count           = var.default_node_pool[0].min_count
    max_count           = var.default_node_pool[0].max_count

    #only_critical_addons_enabled = var.default_node_pool[0].criticalOnly
    availability_zones           = var.availability_zones
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  depends_on = [data.azurerm_resource_group.cluster]
}
##- Additional nodepools -##
resource "azurerm_kubernetes_cluster_node_pool" "additional_cluster" {
  for_each = { for np in local.additional_node_pools : np.name => np }

  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster.id
  name                  = each.value.name
  vm_size               = each.value.vm_size
  node_count            = each.value.node_count
  #vnet_subnet_id        = var.subnet_id

  enable_auto_scaling = each.value.enable_auto_scaling
  min_count           = each.value.min_count
  max_count           = each.value.max_count

  node_labels = each.value.node_labels
  node_taints = each.value.node_taints

  availability_zones = var.availability_zones

  tags = each.value.tags
}
