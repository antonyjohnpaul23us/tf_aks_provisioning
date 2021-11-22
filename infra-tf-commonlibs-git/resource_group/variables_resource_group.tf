variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "tf_workspace_tags" {
  type = map
  default = {}
}
variable "tf_module_tags" {
  type = map
  default = {}
}
