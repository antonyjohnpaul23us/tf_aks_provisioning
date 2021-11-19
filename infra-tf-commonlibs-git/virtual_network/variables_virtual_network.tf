variable "vnet_name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "vnet_address_space" {
  type = list(string)
}
variable "tf_workspace_tags" {
  type = map
  default = {}
}
variable "tf_module_tags" {
  type = map
  default = {}
}
