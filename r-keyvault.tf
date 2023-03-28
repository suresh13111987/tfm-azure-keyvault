resource "azurerm_key_vault" "main" {
  name = var.unique_name ? substr("${local.name}-${random_string.unique.result}", 0, 24) : local.name

  location            = local.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags                = local.tags

  tenant_id = local.tenant_id

  sku_name = var.sku_name

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  purge_protection_enabled    = var.purge_protection_enabled
  soft_delete_retention_days  = var.soft_delete_retention_days
  
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = var.ip_whitelist
    virtual_network_subnet_ids = var.subnet_whitelist
  }
  
  lifecycle {
    prevent_destroy = true
  }

}

resource "azurerm_key_vault_access_policy" "readers_policy" {
  for_each = toset(var.reader_object_ids)

  object_id    = each.value
  tenant_id    = local.tenant_id
  key_vault_id = azurerm_key_vault.main.id

  key_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]

  certificate_permissions = [
    "Get",
    "List",
  ]
}

resource "azurerm_key_vault_access_policy" "admin_policy" {
  for_each = toset(
    concat(
      var.admin_object_ids, [
        data.azurerm_client_config.current_config.object_id
      ]
    )
  )

  object_id    = each.value
  tenant_id    = local.tenant_id
  key_vault_id = azurerm_key_vault.main.id

  key_permissions = [
    "Backup",
    "Create",
    "Decrypt",
    "Delete",
    "Encrypt",
    "Get",
    "Import",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Sign",
    "UnwrapKey",
    "Update",
    "Verify",
    "WrapKey",
  ]

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set",
  ]

  certificate_permissions = [
    "Backup",
    "Create",
    "Delete",
    "DeleteIssuers",
    "Get",
    "GetIssuers",
    "Import",
    "List",
    "ListIssuers",
    "ManageContacts",
    "ManageIssuers",
    "Purge",
    "Recover",
    "Restore",
    "SetIssuers",
    "Update",
  ]
}

resource "random_string" "unique" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}