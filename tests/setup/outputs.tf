output "random_name" {
  value       = random_pet.name.id
  description = "The randomly generated name."
}

output "resource_group_name" {
  value       = azurerm_resource_group.resource_group.name
  description = "The name of the resource group."
}

output "resource_group_id" {
  value       = azurerm_resource_group.resource_group.id
  description = "The ID of the resource group."
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The name of the virtual network."
}

output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The ID of the virtual network."
}

output "subnet_name" {
  value       = azurerm_subnet.subnet.name
  description = "The name of the subnet."
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "The ID of the subnet."
}
