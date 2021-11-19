# Resource Group Creation
module "resourceGroup" {
  source = "../../infra-tf-commonlibs-git/resource_group"
  name                       = var.resource_group
  location                   = var.location
  tf_workspace_tags          = var.tags
  tf_module_tags             = tomap({"purpose"="bb-aks-sample1"})
}

resource "azurerm_container_registry" "acr" {
  name                = "bbsampleacr"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = "Basic"

  identity {
    type = "SystemAssigned"
  }

}

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
  additional_node_pools = []
  tags = var.tags
  namespace = var.namespace
  admin_groups = var.admin_groups

}

resource "azurerm_public_ip" "agw_public_ip" {
  depends_on                   = [module.resourceGroup]
  name                         = "${var.name}-public-ip"
  domain_name_label            = "${var.dns_name}"
  location                     = var.location
  resource_group_name          = "MC_${var.resource_group}_${var.cluster_prefix}${var.name}_${var.location}"
  allocation_method            = var.ingress_public_ip_address_allocation
  sku                          = var.ingress_public_ip_sku
  tags                         = var.tags
}

data "azurerm_kubernetes_cluster" "example" {
  #depends_on          = [module.kubernetes-cluster]
  depends_on          = [module.resourceGroup]
  name                = "${var.cluster_prefix}${var.name}"#var.name
  resource_group_name = var.resource_group
}

### [AntonyJohnPaul] - If you're wondering why I'm using kube_admin_config instead of kube_config - https://www.kubernet.dev/terraform-and-aad-rbac-integration-for-aks/
provider "kubernetes" {
  host                   = "${data.azurerm_kubernetes_cluster.example.kube_admin_config.0.host}"
  client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.cluster_ca_certificate)}"
}

provider "helm" {
  kubernetes {
    host                   = "${data.azurerm_kubernetes_cluster.example.kube_admin_config.0.host}"
    client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_certificate)}"
    client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.cluster_ca_certificate)}"
  }
}
     

provider "kubectl" {
    host                   = "${data.azurerm_kubernetes_cluster.example.kube_admin_config.0.host}"
    client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_certificate)}"
    client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.cluster_ca_certificate)}"
#   host                   = var.eks_cluster_endpoint
#   cluster_ca_certificate = base64decode(var.eks_cluster_ca)
#   token                  = data.aws_eks_cluster_auth.main.token
    load_config_file       = false
}

resource "helm_release" "nginx" {
  depends_on          = [module.kubernetes-cluster]
  name       = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.nginx_namespace
  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.agw_public_ip.ip_address
  }
}

resource "helm_release" "cert_manager" {
  depends_on          = [module.kubernetes-cluster]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.6.0"
  namespace  = "cert-manager"
  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "kubernetes_manifest" "ClusterIssuer" {
  depends_on          = [module.kubernetes-cluster]
  manifest = yamldecode(file("../setup/cluster-issuer.yaml"))
}

# resource "kubernetes_manifest" "hwld_one" {
#     manifest = yamldecode(file("../setup_sample/aks-helloworld-one.yaml"))
# }

# resource "kubernetes_manifest" "hwld_one_ingress" {
#     manifest = yamldecode(file("../setup_sample/hello-world-ingress.yaml"))
# }


# Setup Jenkins
resource "helm_release" "jenkins" {
  depends_on          = [module.kubernetes-cluster]
  name       = "jenkins"
  #repository = "https://charts.jetstack.io"
  chart      = "../../HelmCharts/charts/jenkins"
  #version    = "1.6.0"
  namespace  = "jenkins"
#   values = [
#     "${file("values.yaml")}"
#   ]
  set {
    name  = "controller.adminPassword"
    value = "ajpjenkinspass"
  }

}

