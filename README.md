# terraform-azurerm-container-registry

An opinionated example of how to create and maintain a Terraform module.

This module offers the following features:

- Create a Container Registry
- Create a Private Endpoint for the Container Registry
- Create a Private DNS Zone Group for the Private Endpoint

> [!WARNING]
> Major version Zero (0.y.z) is for initial development. A module **should not** be considered stable till at least it is major version one (1.0.0) or greater. Changes will always be via new versions being published and no changes will be made to existing published versions.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8, < 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.95 |

## Usage

The basic usage of this module is as follows:

```hcl
module "container_registry" {
  source = "<module-source>"

  # Required variables
  name =
  resource_group_name =

  # Optional variables
  admin_enabled = false
  anonymous_pull_enabled = false
  data_endpoint_enabled = false
  export_policy_enabled = true
  georeplications = []
  location = null
  network_rule_bypass_option = "None"
  private_endpoint = null
  public_network_access_enabled = false
  retention_policy = null
  sku = "Premium"
  tags = {}
  zone_redundancy_enabled = true
}
```

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.95 |

## Resources

| Name | Type |
|------|------|
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) | resource |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the container registry. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group where the resources will be deployed. | `string` | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Specifies whether the admin user is enabled. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_anonymous_pull_enabled"></a> [anonymous\_pull\_enabled](#input\_anonymous\_pull\_enabled) | Specifies whether anonymous (unauthenticated) pull access to this container registry is allowed. Requires `Standard` or `Premium` sku. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_data_endpoint_enabled"></a> [data\_endpoint\_enabled](#input\_data\_endpoint\_enabled) | Specifies whether to enable dedicated data endpoints for this container registry. Requires `Premium` sku. | `bool` | `false` | no |
| <a name="input_export_policy_enabled"></a> [export\_policy\_enabled](#input\_export\_policy\_enabled) | Specifies whether export policy is enabled. Defaults to `true`. In order to set it to false, make sure the `public_network_access_enabled` is also set to false. | `bool` | `true` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | A list of geo-replication configurations for the container cegistry. Supported fields are:<br><br>- `location`                  - (Required) The geographic location where the container registry should be geo-replicated.<br>- `zone_redundancy_enabled`   - (Optional) Enables or disables zone redundancy. Defaults to `true`.<br>- `regional_endpoint_enabled` - (Optional) Enables or disables the regional endpoint. Defaults to `true`.<br>- `tags`                      - (Optional) A map of additional tags for the geo-replication configuration. | <pre>list(object({<br>    location                  = string<br>    regional_endpoint_enabled = optional(bool, true)<br>    zone_redundancy_enabled   = optional(bool, true)<br>    tags                      = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the resource should be deployed. If null, the location will be inferred from the resource group location. | `string` | `null` | no |
| <a name="input_network_rule_bypass_option"></a> [network\_rule\_bypass\_option](#input\_network\_rule\_bypass\_option) | Specifies whether to allow trusted Azure services access to a network restricted container registry. Defaults to `None`. Possible values are `AzureServices` and `None`. | `string` | `"None"` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | A map of private endpoint configuration. Supported fields are:<br><br>- `name`                    - (Required) The name of the private endpoint.<br>- `subnet_id`               - (Required) The id of the subnet in which the private endpoint will be created.<br>- `private_dns_zone_id`     - (Optional) The id of the private dns zone to associate with the private endpoint. Defaults to `null`.<br>- `network_interface_name`  - (Optional) The name of the network interface. Defaults to `null`.<br>- `tags`                    - (Optional) A mapping of tags to assign to the private endpoint. Defaults to `{}`. | <pre>object({<br>    name                   = string<br>    subnet_id              = string<br>    private_dns_zone_id    = optional(string)<br>    network_interface_name = optional(string)<br>    tags                   = optional(map(string))<br>  })</pre> | `null` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Specifies whether or not public network access is allowed for the container registry. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_retention_policy"></a> [retention\_policy](#input\_retention\_policy) | If enabled, this retention policy will purge an untagged manifest after a specified number of days. Supported fields are:<br><br>- `days`    - (Optional) The number of days before the policy. Defaults to `7`.<br>- `enabled` - (Optional) Whether the retention policy is enabled. Defaults to `false`. | <pre>object({<br>    days    = optional(number, 7)<br>    enabled = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The sku of the container registry. Defaults to `Premium`. Possible values are `Basic`, `Standard` and `Premium`. | `string` | `"Premium"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the container registry. Defaults to `{}`. | `map(string)` | `{}` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Specifies whether or not zone redundancy is enabled for this container registry. Defaults to `true`. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin"></a> [admin](#output\_admin) | The admin credentials of the container registry. |
| <a name="output_id"></a> [id](#output\_id) | The resource id of the container registry. |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | The login server of the container registry. |
| <a name="output_name"></a> [name](#output\_name) | The name of the container registry. |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | The resource id of the private endpoint. |
| <a name="output_private_endpoint_ip"></a> [private\_endpoint\_ip](#output\_private\_endpoint\_ip) | The private ip address of the private endpoint. |

## Modules

No modules.
