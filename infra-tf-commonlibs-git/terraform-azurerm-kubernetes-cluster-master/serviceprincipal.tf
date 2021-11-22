# ###########################
# ##-- SERVICE PRINCIPAL --##
# ###########################
# resource "random_integer" "appnumber" {
#   min = 5
#   max = 20
# }
# resource "azuread_application" "kubeapp" {
#   name = format("k8s-%d", random_integer.appnumber.result)
# }
# resource "azuread_service_principal" "cluster" {
#   application_id = azuread_application.kubeapp.application_id
# }
# ## Create a password for the service principal with the *random_password* resource
# ## and use it for the service principal
# resource "random_password" "cluster" {
#   length  = 32
#   special = true
# }
# resource "azuread_service_principal_password" "cluster" {
#   service_principal_id = azuread_service_principal.cluster.id
#   value                = random_password.cluster.result
#   end_date_relative    = "8766h"
# }