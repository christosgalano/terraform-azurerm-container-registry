variable "location" {
  type        = string
  description = "The location of the resource group in which to create the resources."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the resources."
}

variable "vnet_name" {
  type        = string
  description = "The name of the virtual network in which to create the private endpoint."
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet in which to create the private endpoint."
}
