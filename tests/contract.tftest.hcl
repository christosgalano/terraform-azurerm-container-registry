mock_provider "azurerm" {}

variables {
  name                = "crtftest"
  location            = "northeurope"
  resource_group_name = "rg-azurerm-container-registry-tftest"
}

run "valid_configuration" {
  command = plan

  variables {
    private_endpoint = {
      name      = "pep-tftest"
      subnet_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-tftest/providers/Microsoft.Network/virtualNetworks/vnet-tftest/subnets/snet-tftest"
    }
  }

  assert {
    condition     = azurerm_container_registry.this.name == "crtftest"
    error_message = "Container registry name did not match expected."
  }

  assert {
    condition     = azurerm_private_endpoint.this[0].name == "pep-tftest"
    error_message = "Private endpoint name did not match expected."
  }
}

run "invalid_resource_names" {
  command = plan

  variables {
    name = "cr-tftest"
    private_endpoint = {
      name                   = "-pep-tftest"
      subnet_id              = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-tftest/providers/Microsoft.Network/virtualNetworks/vnet-tftest/subnets/snet-tftest"
      network_interface_name = "nic-tftest-nic-tftest-nic-tftest-nic-tftest-nic-tftest-nic-tftest-nic-tftest"
    }
  }

  expect_failures = [
    var.name,
    var.private_endpoint.name,
    var.private_endpoint.network_interface_name
  ]
}

run "invalid_sku_and_network_rule_values" {
  command = plan

  variables {
    sku                        = "Invalid"
    network_rule_bypass_option = "Invalid"
  }

  expect_failures = [
    var.sku,
    var.network_rule_bypass_option
  ]
}

run "zone_redundancy_enabled_with_non_premium_sku" {
  command = plan

  variables {
    sku                     = "Standard"
    zone_redundancy_enabled = true
  }

  expect_failures = [azurerm_container_registry.this]
}

run "georeplication_with_non_premium_sku" {
  command = plan

  variables {
    sku = "Standard"
    georeplications = [
      {
        location                  = "westeurope"
        regional_endpoint_enabled = false
        zone_redundancy_enabled   = false
      }
    ]
  }

  expect_failures = [azurerm_container_registry.this]
}

run "private_access_with_non_premium_sku" {
  command = plan

  variables {
    sku                           = "Standard"
    public_network_access_enabled = false
  }

  expect_failures = [azurerm_container_registry.this]
}

run "private_endpoint_with_public_network_access_enabled" {
  command = plan

  variables {
    public_network_access_enabled = true
    private_endpoint = {
      name      = "pep-tftest"
      subnet_id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/rg-tftest/providers/Microsoft.Network/virtualNetworks/vnet-tftest/subnets/snet-tftest"
    }
  }

  expect_failures = [azurerm_private_endpoint.this]
}

