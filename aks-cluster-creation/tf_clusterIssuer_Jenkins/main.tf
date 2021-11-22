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

provider "helm" {
  kubernetes {
    host                   = "${data.azurerm_kubernetes_cluster.example.kube_admin_config.0.host}"
    client_certificate     = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_certificate)}"
    client_key             = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(data.azurerm_kubernetes_cluster.example.kube_admin_config.0.cluster_ca_certificate)}"
  }
}

resource "kubernetes_manifest" "ClusterIssuer" {
  manifest = yamldecode(file("../setupFiles/cluster-issuer.yaml"))
}

# Setup Jenkins
resource "helm_release" "jenkins" {
  name       = "jenkins"
  chart      = "../../HelmCharts/charts/jenkins"
  namespace  = "jenkins"
  set {
    name  = "controller.adminPassword"
    value = var.jenkins_admin_password
  }
}