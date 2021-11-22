output "aks_host" {
  value = azurerm_kubernetes_cluster.cluster.kube_admin_config.0.host
}

output "aks_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_admin_config.0.client_certificate
}

output "aks_key" {
  value = azurerm_kubernetes_cluster.cluster.kube_admin_config.0.client_key
}

output "aks_cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_admin_config.0.cluster_ca_certificate
}

output "kube_config" {
  value       = azurerm_kubernetes_cluster.cluster.kube_config_raw
  description = "kubeconfig for kubectl access."
  sensitive   = true
}
output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.cluster.name
}

output "kubernetes_cluster_resource_group_name" {
  value = azurerm_kubernetes_cluster.cluster.resource_group_name
}