# Resource Group Creation
module "resourceGroup" {
  source = "../../infra-tf-commonlibs-git/resource_group"
  name                       = var.resource_group
  location                   = var.location
  tf_workspace_tags          = var.tags
  tf_module_tags             = tomap({"purpose"="bb-aks"})
}

# resource "azurerm_container_registry" "acr" {
#   depends_on          = [module.resourceGroup]
#   name                = "bbsampleacr"
#   resource_group_name = var.resource_group
#   location            = var.location
#   sku                 = "Basic"

#   identity {
#     type = "SystemAssigned"
#   }
# }

module "kubernetes-cluster" {
  source = "../../infra-tf-commonlibs-git/terraform-azurerm-kubernetes-cluster-master"
  depends_on          = [module.resourceGroup]

    name = var.name
    resource_group = var.resource_group
    location = var.location
    availability_zones = var.availability_zones
    kubernetes_version_prefix = var.kubernetes_version_prefix
    role_based_access_control = var.role_based_access_control
    enable_pod_security_policy = var.enable_pod_security_policy
    enable_azure_policy = var.enable_azure_policy

  default_node_pool = var.default_node_pool

### [AntonyJohnPaul] - Additional node pools are disabled as not requreid for the sample cluster's suggested Load
  additional_node_pools          = []
  tags                           = var.tags
  namespace                      = var.namespace
  admin_groups                   = var.admin_groups
}

resource "time_sleep" "wait_120_seconds_aks" {
  depends_on                     = [module.kubernetes-cluster]
  create_duration                = "120s"
}

data "azurerm_resource_group" "MC_RG" {
  #depends_on                   = [module.resourceGroup]
  depends_on                   = [time_sleep.wait_120_seconds_aks]
  name = "MC_${var.resource_group}_${var.cluster_prefix}${var.name}_${var.location}"
}

resource "azurerm_public_ip" "agw_public_ip" {
  depends_on                   = [time_sleep.wait_120_seconds_aks]
  #depends_on                   = [data.azurerm_resource_group.MC_RG]
  name                         = "${var.name}-public-ip"
  domain_name_label            = "${var.dns_name}"
  location                     = var.location
  resource_group_name          = data.azurerm_resource_group.MC_RG.name#"MC_${var.resource_group}_${var.cluster_prefix}${var.name}_${var.location}"
  allocation_method            = var.ingress_public_ip_address_allocation
  sku                          = var.ingress_public_ip_sku
  tags                         = var.tags
}

resource "local_file" "key" {
  depends_on                   = [time_sleep.wait_120_seconds_aks]
  filename                     = "aks_kubeconfig"
  content                      = "${module.kubernetes-cluster.kube_config}"
}
