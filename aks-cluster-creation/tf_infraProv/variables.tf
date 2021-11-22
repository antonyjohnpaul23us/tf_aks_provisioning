#########################
##-- INPUT VARIABLES --##
#########################

variable "name" {
  type        = string
  description = "Name to make the cluster unique. Example, Projectname or business unit."
}
variable "dns_name" {
  type        = string
  description = "Name to DNS"
}

variable "cluster_prefix" {
  type        = string
  description = "Cluster deployment prefix"
  default     = "cluster-"
}

variable "resource_group" {
  type        = string
  description = "The resource group you want to deploy the AKS cluster in."
}

variable "location" {
  type        = string
  description = "The location you want to deploy the AKS cluster to."
}
variable "availability_zones" {
  type        = list(string)
  description = "A list of availability zones that the cluster will use. Defaults to 1, 2 and 3."
  default     = ["1", "2", "3"]
}

### Public IP Addres Vars
variable "ingress_public_ip_address_allocation" {
  description = "ingress Public Ip Address Allocation Type."
  default     = "Static"
}

variable "ingress_public_ip_sku" {
  description = "ingress Public Ip Sku."
  default     = "Standard"
}

variable "kubernetes_version" {
  type    = string
  default = "unknown"
}

variable "kubernetes_version_prefix" {
  type    = string
  default = "1.18"
}

variable "kubernetes_include_preview" {
  type    = string
  default = false
}

variable "role_based_access_control" {
  type    = bool
  default = true
}

variable "enable_pod_security_policy" {
  type    = bool
  default = false
}

variable "enable_azure_policy" {
  type    = bool
  default = true
}

variable "default_node_pool" {
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    criticalOnly        = bool
  }))
  default = [
    {
      name                = "default"
      vm_size             = "Standard_D2s_v3"
      node_count          = null
      enable_auto_scaling = false
      min_count           = 1
      max_count           = 3
      criticalOnly        = false
    }
  ]
}

variable "additional_node_pools" {
  type = list(object({
    name                = string
    vm_size             = string
    node_count          = number
    enable_auto_scaling = bool
    min_count           = number
    max_count           = number
    node_labels         = map(string)
    node_taints         = any
    tags                = map(string)
  }))
}

variable "tags" {
  type = map(string)
}

variable "namespace" {
  type = list(string)
}

variable "oms_agent_enabled" {
    type= string
    default = false
}
variable "admin_groups" {
  type = list(string)
}

### For Helm Charts
variable "nginx_namespace" {
  type = string
  default = "ingress-basic"
}
