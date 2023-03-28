locals {
  name = coalesce(
    var.custom_name,
    "${var.pep_defaults.app_prefix}-${var.pep_defaults.environment}-kv"
  )

  resource_group_name = coalesce(
    var.custom_resource_group,
    var.pep_defaults.resource_groups.default
  )

  location = coalesce(
    var.custom_location,
    data.azurerm_resource_group.main.location
  )

  tags = merge(
    var.pep_defaults.tags,
    var.extra_tags
  )

  tenant_id = data.azurerm_client_config.current_config.tenant_id
}

