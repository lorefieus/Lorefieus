output "function_app_url" {
  value = azurerm_linux_function_app.proxy.default_hostname
}

output "key_vault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "sql_server_name" {
  value = azurerm_mssql_server.main.name
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}

output "openai_resource_id" {
  value = azurerm_cognitive_account.openai.id
}

output "openai_key_vault_reference" {
  value = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=openai-api-key)"
  description = "Key Vault reference for OpenAI API key"
}
