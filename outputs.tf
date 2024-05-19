output "id" {
  value       = azurerm_container_registry.this.id
  description = "The resource id of the container registry."
}

output "name" {
  value       = azurerm_container_registry.this.name
  description = "The name of the container registry."
}
output "login_server" {
  value       = azurerm_container_registry.this.login_server
  description = "The login server of the container registry."
}

output "private_endpoint_id" {
  value       = try(azurerm_private_endpoint.this[0].id, null)
  description = "The resource id of the private endpoint."
}

output "private_endpoint_ip" {
  value       = try(azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address, null)
  description = "The private ip address of the private endpoint."
}
