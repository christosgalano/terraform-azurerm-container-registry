terraform {
  required_version = ">= 1.6, < 2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.95"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = "rg-${var.environment}"
}

data "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = "vnet-${var.environment}"
}

data "azurerm_private_dns_zone" "azurecr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = "rg-central"
}

resource "random_string" "suffix" {
  length  = 7
  special = false
  upper   = false
  numeric = false
}

module "container_registry" {
  source = "../../"

  name                = "acr${var.environment}${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.rg.name

  sku                     = "Premium"
  admin_enabled           = false
  zone_redundancy_enabled = true
  export_policy_enabled   = false

  retention_policy = {
    days    = 7
    enabled = true
  }

  georeplications = [
    {
      location                = "westeurope"
      zone_redundancy_enabled = true
    },
    {
      location                = "eastus"
      zone_redundancy_enabled = true
    }
  ]

  public_network_access_enabled = false
  private_endpoint = {
    name                = "pep-cr-${var.environment}-${random_string.suffix.result}"
    subnet_id           = data.azurerm_subnet.default.id
    private_dns_zone_id = data.azurerm_private_dns_zone.azurecr.id
    tags = {
      environment = var.environment
    }
  }
}
