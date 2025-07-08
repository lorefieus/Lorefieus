output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Name of the created resource group"
}

output "storage_account_name" {
  value       = azurerm_storage_account.function.name
  description = "Name of the Function App storage account"
}

output "function_app_name" {
  value       = azurerm_linux_function_app.proxy.name
  description = "Name of the Function App"
}

output "function_app_url" {
  value       = "https://${azurerm_linux_function_app.proxy.default_hostname}"
  description = "URL of the Function App"
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "Name of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "URI of the Key Vault"
}

output "sql_server_name" {
  value       = azurerm_mssql_server.main.name
  description = "Name of the SQL Server"
}

output "sql_server_fqdn" {
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
  description = "Fully qualified domain name of the SQL Server"
}

output "sql_database_name" {
  value       = azurerm_mssql_database.main.name
  description = "Name of the SQL Database"
}

output "openai_endpoint" {
  value       = azurerm_cognitive_account.openai.endpoint
  description = "OpenAI service endpoint"
}

output "openai_account_name" {
  value       = azurerm_cognitive_account.openai.name
  description = "Name of the OpenAI Cognitive Account"
}

output "application_insights_instrumentation_key" {
  value       = azurerm_application_insights.main.instrumentation_key
  description = "Application Insights instrumentation key"
  sensitive   = true
}

output "application_insights_connection_string" {
  value       = azurerm_application_insights.main.connection_string
  description = "Application Insights connection string"
  sensitive   = true
}

output "infrastructure_storage_account" {
  value       = data.azurerm_storage_account.infrastructure.name
  description = "Name of the infrastructure storage account"
}

output "infrastructure_sas_token" {
  value       = data.azurerm_storage_account_sas.infrastructure_sas.sas
  description = "SAS token for infrastructure storage account"
  sensitive   = true
}

output "deployment_summary" {
  value = <<-EOT
    Lorefieus RAG Infrastructure Deployment Complete!
    
    📋 Resources Created:
    • Resource Group: ${azurerm_resource_group.main.name}
    • Function App: ${azurerm_linux_function_app.proxy.name}
    • SQL Server: ${azurerm_mssql_server.main.fully_qualified_domain_name}
    • SQL Database: ${azurerm_mssql_database.main.name}
    • Key Vault: ${azurerm_key_vault.main.name}
    • OpenAI Account: ${azurerm_cognitive_account.openai.name}
    
    🔧 Automated SQL Scripts:
    • Script 01: Table creation (automated)
    • Script 02: Data loading (automated)
    
    📊 Data Source:
    • Infrastructure Storage: ${data.azurerm_storage_account.infrastructure.name}
    • Dataset: ${var.walmart_dataset_filename}
    
    🚀 Next Steps:
    1. Function App is ready for RAG implementation
    2. SQL Scripts 03-08 can be run manually for OpenAI integration
    3. Test the RAG functionality with sample queries
    
    📝 Connection Details:
    • Function App URL: https://${azurerm_linux_function_app.proxy.default_hostname}
    • SQL Server: ${azurerm_mssql_server.main.fully_qualified_domain_name}
    • Key Vault: ${azurerm_key_vault.main.vault_uri}
  EOT
  description = "Summary of the deployment"
}
