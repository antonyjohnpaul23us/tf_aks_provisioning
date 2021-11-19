#########################
##-- INPUT VARIABLE OVERWRITES - SAMPLE 1 --##
#########################
name = "bb-aks-sample1"
dns_name ="ajpaks"
resource_group = "bb-aks-sample1-rg"
location = "eastus"
availability_zones = ["1"]
kubernetes_version_prefix = "1.20"
role_based_access_control = true
enable_pod_security_policy = false
enable_azure_policy = true
default_node_pool = [
    {
      name                = "default"
      vm_size             = "Standard_B4ms"
      node_count          = "1"
      enable_auto_scaling = false
      min_count           = null
      max_count           = null
      criticalOnly        = false
    }
]
additional_node_pools = []
namespace = ["ingress-basic","jenkins","dev","cert-manager"]
nginx_namespace = "ingress-basic"
admin_groups = ["d3d253f5-a5f7-40ff-a708-3ae4012cfdd8"]
tags = {
    "resource-owner"                  = "Antony John Paul",
    "provisioned-by"                  = "terraform"
}
# tf_workspace_tags = {
#     "resource-owner"                  = "Antony John Paul",
#     "provisioned-by"                  = "terraform"
# }

# variable "namespace" {
#   type = list(string)
# }

# variable "log_analytics" {
#   type = string
# }

# variable "oms_agent_enabled" {
#     type= string
#     default = false
# }
# variable "admin_groups" {
#   type = list(string)
# }

# variable "resource_group" {
#   type        = string
#   description = "The resource group you want to deploy the AKS cluster in."
# }

# variable "location" {
#   type        = string
#   description = "The location you want to deploy the AKS cluster to."
# }
# variable "availability_zones" {
#   type        = list(string)
#   description = "A list of availability zones that the cluster will use. Defaults to 1, 2 and 3."
#   default     = ["1", "2", "3"]
# }

# variable "network_policy" {
#   type        = string
#   description = "Sets up network policy to be used with Azure CNI."
#   default     = "calico"
# }
# variable "subnet_id" {}

# variable "kubernetes_version" {
#   type    = string
#   default = "unknown"
# }
# variable "kubernetes_version_prefix" {
#   type    = string
#   default = "1.18"
# }
# variable "kubernetes_include_preview" {
#   type    = string
#   default = false
# }

# variable "role_based_access_control" {
#   type    = bool
#   default = true
# }

# variable "enable_pod_security_policy" {
#   type    = bool
#   default = false
# }

# variable "enable_azure_policy" {
#   type    = bool
#   default = true
# }

# variable "default_node_pool" {
#   type = list(object({
#     name                = string
#     vm_size             = string
#     node_count          = number
#     enable_auto_scaling = bool
#     min_count           = number
#     max_count           = number
#     criticalOnly        = bool
#   }))
#   default = [
#     {
#       name                = "default"
#       vm_size             = "Standard_D2s_v3"
#       node_count          = null
#       enable_auto_scaling = false
#       min_count           = 1
#       max_count           = 3
#       criticalOnly        = false
#     }
#   ]
# }

# variable "additional_node_pools" {
#   type = list(object({
#     name                = string
#     vm_size             = string
#     node_count          = number
#     enable_auto_scaling = bool
#     min_count           = number
#     max_count           = number
#     node_labels         = map(string)
#     node_taints         = any
#     tags                = map(string)
#   }))
# }

# variable "tags" {
#   type = map(string)
# }

# variable "namespace" {
#   type = list(string)
# }

# # variable "log_analytics" {
# #   type = string
# # }

# variable "oms_agent_enabled" {
#     type= string
#     default = false
# }
# variable "admin_groups" {
#   type = list(string)
# }
