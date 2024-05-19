locals {
  resource_group_location = try(data.azurerm_resource_group.resource_group[0].location, null)
}

data "azurerm_resource_group" "resource_group" {
  count = var.location == null ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_container_registry" "this" {
  location            = coalesce(var.location, local.resource_group_location)
  resource_group_name = var.resource_group_name

  name                          = var.name
  sku                           = var.sku
  tags                          = var.tags
  admin_enabled                 = var.admin_enabled
  data_endpoint_enabled         = var.data_endpoint_enabled
  export_policy_enabled         = var.export_policy_enabled
  anonymous_pull_enabled        = var.anonymous_pull_enabled
  zone_redundancy_enabled       = var.zone_redundancy_enabled
  network_rule_bypass_option    = var.network_rule_bypass_option
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "georeplications" {
    for_each = toset(var.georeplications)
    content {
      location                = georeplications.value.location
      tags                    = georeplications.value.tags
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
    }
  }

  dynamic "retention_policy" {
    for_each = var.retention_policy != null ? { retention_policy = var.retention_policy } : {}
    content {
      days    = retention_policy.value.days
      enabled = retention_policy.value.enabled
    }
  }

  lifecycle {
    precondition {
      condition     = var.zone_redundancy_enabled && var.sku == "Premium" || !var.zone_redundancy_enabled
      error_message = "The `Premium` sku is required if zone redundancy is enabled."
    }

    precondition {
      condition     = length(var.georeplications) > 0 && var.sku == "Premium" || length(var.georeplications) == 0
      error_message = "The `Premium` sku is required for georeplications."
    }

    precondition {
      condition     = !var.public_network_access_enabled && var.sku == "Premium" || var.public_network_access_enabled
      error_message = "The `Premium` sku is required if public network access is disabled."
    }

    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "this" {
  count = var.private_endpoint != null ? 1 : 0

  location            = var.location
  resource_group_name = var.resource_group_name

  name                          = var.private_endpoint.name
  subnet_id                     = var.private_endpoint.subnet_id
  tags                          = var.private_endpoint.tags
  custom_network_interface_name = var.private_endpoint.network_interface_name

  private_service_connection {
    is_manual_connection           = false
    name                           = "pse-${var.name}"
    subresource_names              = ["registry"]
    private_connection_resource_id = azurerm_container_registry.this.id
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_endpoint.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "dns-zone-group-${var.name}"
      private_dns_zone_ids = [var.private_endpoint.private_dns_zone_id]
    }
  }

  lifecycle {
    precondition {
      condition     = !azurerm_container_registry.this.public_network_access_enabled
      error_message = "The container registry must have public network access disabled to create a private endpoint."
    }

    ignore_changes = [tags]
  }
}
