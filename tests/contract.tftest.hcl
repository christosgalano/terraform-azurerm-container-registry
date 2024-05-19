mock_provider "azurerm" {}

variables {
  name                = "crtftest"
  location            = "northeurope"
  resource_group_name = "rg-azurerm-container-registry-tftest"
}

run "valid_names" {
  command = plan

  variables {
    name = "crtftest"
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

run "invalid_names" {
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

run "disallowed_values" {
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
