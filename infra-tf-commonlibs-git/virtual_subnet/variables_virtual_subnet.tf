variable "virtual_network_name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "subnet_address_prefix" {
  type = list(string)
}
variable "subnet_name" {
  type = string
}
variable "enforce_private_link_endpoint_network_policies" {
  type = bool
  default = false
}
