#########################
##-- INPUT VARIABLE OVERWRITES - SAMPLE 1 --##
#########################
name = "bb-aks"
dns_name ="ajp-aks-bb"
resource_group = "bb-aks-rg"
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
