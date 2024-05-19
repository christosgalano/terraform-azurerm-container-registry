terraform {
  required_version = ">= 1.6, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.95"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.6"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}-${random_string.suffix.result}"
  location = "northeurope"
}

module "container_registry" {
  source = "../../"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  name = "acr${var.environment}${random_string.suffix.result}"
  sku  = "Premium"
  tags = {
    environment = var.environment
  }

  admin_enabled                 = false
  zone_redundancy_enabled       = true
  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"

  georeplications = [
    {
      location                = "westeurope"
      zone_redundancy_enabled = true
      tags = {
        environment = var.environment
      }
    },
    {
      location                = "eastus"
      zone_redundancy_enabled = true
      tags = {
        environment = var.environment
      }
    }
  ]
}
