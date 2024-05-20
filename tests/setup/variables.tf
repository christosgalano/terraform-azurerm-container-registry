variable "location" {
  type        = string
  description = "The location of the resource group in which to create the resources."
}

variable "resource_group_prefix" {
  type        = string
  description = "The prefix of the resource group in which to create the resources."
}

variable "vnet_prefix" {
  type        = string
  description = "The prefix of the virtual network in which to create the private endpoint."
}

variable "subnet_prefix" {
  type        = string
  description = "The prefix of the subnet in which to create the private endpoint."
}
