### General ###
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "location" {
  type        = string
  default     = null
  description = "Azure region where the resource should be deployed. If null, the location will be inferred from the resource group location."
}

### Container Registry ###
variable "name" {
  type        = string
  description = "The name of the container registry."
  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.name))
    error_message = "The name must be between 5 and 50 characters long and can only contain alphanumeric characters."
  }
}

variable "sku" {
  type        = string
  default     = "Premium"
  description = "The sku of the container registry. Defaults to `Premium`. Possible values are `Basic`, `Standard` and `Premium`."
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The sku name must be either `Basic`, `Standard` or `Premium`."
  }
}

variable "admin_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether the admin user is enabled. Defaults to `false`."
}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether or not zone redundancy is enabled for this container registry. Defaults to `true`."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether or not public network access is allowed for the container registry. Defaults to `false`."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the container registry. Defaults to `{}`."
}

variable "export_policy_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether export policy is enabled. Defaults to `true`. In order to set it to false, make sure the `public_network_access_enabled` is also set to false."
}

variable "anonymous_pull_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether anonymous (unauthenticated) pull access to this container registry is allowed. Requires `Standard` or `Premium` sku. Defaults to `false`."
}

variable "data_endpoint_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable dedicated data endpoints for this container registry. Requires `Premium` sku."
}

variable "network_rule_bypass_option" {
  type        = string
  default     = "None"
  description = "Specifies whether to allow trusted Azure services access to a network restricted container registry. Defaults to `None`. Possible values are `AzureServices` and `None`."
  validation {
    condition     = contains(["AzureServices", "None"], var.network_rule_bypass_option)
    error_message = "The network_rule_bypass_option variable must be either `AzureServices` or `None`."
  }
}

variable "georeplications" {
  type = list(object({
    location                  = string
    regional_endpoint_enabled = optional(bool, true)
    zone_redundancy_enabled   = optional(bool, true)
    tags                      = optional(map(string))
  }))
  default     = []
  description = <<DESCRIPTION
A list of geo-replication configurations for the container cegistry. Supported fields are:

- `location`                  - (Required) The geographic location where the container registry should be geo-replicated.
- `zone_redundancy_enabled`   - (Optional) Enables or disables zone redundancy. Defaults to `true`.
- `regional_endpoint_enabled` - (Optional) Enables or disables the regional endpoint. Defaults to `true`.
- `tags`                      - (Optional) A map of additional tags for the geo-replication configuration.

DESCRIPTION
}

variable "retention_policy" {
  type = object({
    days    = optional(number, 7)
    enabled = optional(bool, false)
  })
  default     = null
  description = <<DESCRIPTION
If enabled, this retention policy will purge an untagged manifest after a specified number of days. Supported fields are:

- `days`    - (Optional) The number of days before the policy. Defaults to `7`.
- `enabled` - (Optional) Whether the retention policy is enabled. Defaults to `false`.

DESCRIPTION
}

variable "private_endpoint" {
  type = object({
    name                   = string
    subnet_id              = string
    private_dns_zone_id    = optional(string)
    network_interface_name = optional(string)
    tags                   = optional(map(string))
  })
  default     = null
  description = <<DESCRIPTION
A map of private endpoint configuration. Supported fields are:

- `name`                    - (Required) The name of the private endpoint.
- `subnet_id`               - (Required) The id of the subnet in which the private endpoint will be created.
- `private_dns_zone_id`     - (Optional) The id of the private dns zone to associate with the private endpoint. Defaults to `null`.
- `network_interface_name`  - (Optional) The name of the network interface. Defaults to `null`.
- `tags`                    - (Optional) A mapping of tags to assign to the private endpoint. Defaults to `{}`.

DESCRIPTION
  validation {
    condition = (
      var.private_endpoint == null ? true : (
        can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,62}[a-zA-Z0-9_]$", var.private_endpoint.name)) && (
          var.private_endpoint.network_interface_name == null ? true : (
            can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,78}[a-zA-Z0-9_]$", var.private_endpoint.network_interface_name))
          )
        )
      )
    )
    error_message = <<DESCRIPTION
The private endpoint name must be between 2 and 64 characters long and can only contain alphanumeric characters, hyphens, and underscores; start with an alphanumeric character and end with an alphanumeric character or underscore.
The name of the network interface (if provided) must be 2-80 characters long and contain only alphanumeric characters, hyphens, and underscores; start with an alphanumeric character and end with an alphanumeric character or underscore.

DESCRIPTION
  }
}


variable "test" {
  type        = string
  default     = "test"
  description = "test"
}
