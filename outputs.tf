output "id" {
  description = "Id of the Key Vault"
  value       = azurerm_key_vault.main.id
  depends_on = [
    azurerm_key_vault_access_policy.admin_policy
  ]
}

output "name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.main.name
}

output "uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}


