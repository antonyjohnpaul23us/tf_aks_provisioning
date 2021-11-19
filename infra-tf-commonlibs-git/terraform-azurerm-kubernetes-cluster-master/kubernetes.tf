resource "kubernetes_namespace" "cluster" {
  for_each = toset(var.namespace)
  metadata {
    name = each.key
  }

  depends_on = [azurerm_kubernetes_cluster.cluster]
}