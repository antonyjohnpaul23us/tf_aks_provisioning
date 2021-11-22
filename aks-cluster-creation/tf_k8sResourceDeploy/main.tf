data "terraform_remote_state" "aks" {
  backend = "local"

  config = {
    path = "../tf_infraProv/terraform.tfstate"
  }
}

data "azurerm_kubernetes_cluster" "example" {
  name                = data.terraform_remote_state.aks.outputs.kubernetes_cluster_name
  resource_group_name = data.terraform_remote_state.aks.outputs.kubernetes_cluster_resource_group_name
}

provider "kubernetes" {
  host                   = "${data.azurerm_kubernetes_cluster.example.kube_admin_config.0.host}"
  client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "cluster" {
  for_each = toset(var.namespace)
  metadata {
    name = each.key
  }
}

data "azurerm_public_ip" "LoadBalancerPublicIP" {
  name                = "${var.name}-public-ip"
  resource_group_name = "MC_${var.resource_group}_${var.cluster_prefix}${var.name}_${var.location}"
}

resource "helm_release" "nginx" {
  depends_on = [kubernetes_namespace.cluster]
  name       = "nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.nginx_namespace
  set {
    name  = "controller.service.loadBalancerIP"
    value = data.azurerm_public_ip.LoadBalancerPublicIP.ip_address
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [helm_release.nginx]
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

resource "time_sleep" "wait_180_seconds_cert_manager" {
  depends_on                     = [helm_release.cert_manager]
  create_duration                = "180s"
}