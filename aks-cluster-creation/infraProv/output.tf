output "aks_host" {
  value = "${module.kubernetes-cluster.aks_host}"
}

output "aks_certificate" {
  value = "${module.kubernetes-cluster.aks_certificate}"
  sensitive   = true
}

output "aks_key" {
  value = "${module.kubernetes-cluster.aks_key}"
  sensitive   = true
}

output "aks_cluster_ca_certificate" {
  value = "${module.kubernetes-cluster.aks_cluster_ca_certificate}"
  sensitive   = true
}

# kube_config cna be taken using 'terraform output -raw kube_config > ~/.kube/config' post apply
output "kube_config" {
  value       = "${module.kubernetes-cluster.kube_config}"#azurerm_kubernetes_cluster.k8s.kube_config_raw
  description = "kubeconfig for kubectl access."
  sensitive   = true
}

# output "ingress_public_ip" {
#   value = azurerm_public_ip.agw_public_ip.ip_address
# }

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}