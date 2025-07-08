terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.33.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subid
}

data "azurerm_client_config" "current" {}

# Reference existing infrastructure storage account (not managed by this Terraform)
data "azurerm_storage_account" "infrastructure" {
  name                = var.infrastructure_storage_account
  resource_group_name = var.infrastructure_resource_group
}

# Generate secure password using UUID and timestamp
locals {
  # Create a strong password from UUID + timestamp (deterministic per deployment)
  generated_password = "${replace(uuid(), "-", "")}${formatdate("YYYYMMDD", timestamp())}"
  
  common_tags = {
    environment = var.environment
    project     = "lorefieus-rag"
    managed_by  = "terraform"
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-lore-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
  
  depends_on = [azurerm_resource_group.main]
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = "appi-lore-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
  tags                = local.common_tags
  
  depends_on = [azurerm_resource_group.main, azurerm_log_analytics_workspace.main]
}

# Storage Account for Function App
resource "azurerm_storage_account" "function" {
  name                          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  is_hns_enabled                = true
  tags                          = local.common_tags

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  # Explicitly define network rules to match what Azure creates
  network_rules {
    default_action             = "Allow"
    bypass                     = ["AzureServices"]
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  # Ignore changes that Azure manages automatically
  lifecycle {
    ignore_changes = [
      network_rules
    ]
  }

  depends_on = [azurerm_resource_group.main]
}

# App Service Plan
resource "azurerm_service_plan" "function" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = local.common_tags
  
  depends_on = [azurerm_resource_group.main]
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  tags                        = local.common_tags
  
  depends_on = [azurerm_resource_group.main]
}

# Key Vault Access Policy for Current User
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create", "Delete", "Get", "List", "Update", "Purge", "Recover", "GetRotationPolicy", "SetRotationPolicy"
  ]
  
  secret_permissions = [
    "Set", "Get", "Delete", "List", "Purge", "Recover"
  ]

  depends_on = [azurerm_key_vault.main]
}

# Azure OpenAI Cognitive Account
resource "azurerm_cognitive_account" "openai" {
  name                = var.openai_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "OpenAI"
  sku_name            = "S0"
  tags                = local.common_tags

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_resource_group.main]
}

# Store OpenAI API key in Key Vault
resource "azurerm_key_vault_secret" "openai_api_key" {
  name         = "openai-api-key"
  value        = azurerm_cognitive_account.openai.primary_access_key
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [azurerm_key_vault_access_policy.current_user]
}

# Store generated Database Master Key password in Key Vault
resource "azurerm_key_vault_secret" "database_master_key" {
  name         = "database-master-key-password"
  value        = local.generated_password
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [azurerm_key_vault_access_policy.current_user]
}

# Azure SQL Server - Entra ID Authentication Only
resource "azurerm_mssql_server" "main" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  tags                         = local.common_tags

  azuread_administrator {
    login_username              = var.sql_entra_admin_login
    object_id                   = var.sql_entra_admin_object_id
    tenant_id                   = var.sql_entra_admin_tenant_id != null ? var.sql_entra_admin_tenant_id : data.azurerm_client_config.current.tenant_id
    azuread_authentication_only = true
  }

  identity {
    type = "SystemAssigned"
  }
  
  depends_on = [azurerm_resource_group.main]
}

# SQL Server Auditing Policies
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "main" {
  server_id = azurerm_mssql_server.main.id
  enabled   = false
}

resource "azurerm_mssql_server_extended_auditing_policy" "main" {
  server_id = azurerm_mssql_server.main.id
  enabled   = false
}

# Azure SQL Database
resource "azurerm_mssql_database" "main" {
  name      = var.sql_database_name
  server_id = azurerm_mssql_server.main.id
  sku_name  = "S0"  # Cost-effective for dev environment
  tags      = local.common_tags

  depends_on = [azurerm_resource_group.main, azurerm_mssql_server.main]
}

# Key Vault Access Policy for SQL Server (simplified)
resource "azurerm_key_vault_access_policy" "sql_server_access" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_mssql_server.main.identity[0].principal_id
  
  secret_permissions = [
    "Get", "List"
  ]
  
  depends_on = [azurerm_mssql_server.main]
}

# SQL Server Firewall Rules
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "development" {
  count            = var.dev_ip_address != null ? 1 : 0
  name             = "DevelopmentAccess"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = var.dev_ip_address
  end_ip_address   = var.dev_ip_address
}

# Azure Function App
resource "azurerm_linux_function_app" "proxy" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.function.id
  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key
  tags                       = local.common_tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      python_version = "3.12"
    }
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"              = "python"
    "FUNCTIONS_WORKER_PROCESS_COUNT"        = "1"
    "PYTHON_ISOLATE_WORKER_DEPENDENCIES"    = "1"
    "WEBSITE_RUN_FROM_PACKAGE"              = "1"
    "OPENAI_ENDPOINT"                       = azurerm_cognitive_account.openai.endpoint
    "OPENAI_API_KEY"                        = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=openai-api-key)"
    "SQL_SERVER_NAME"                       = azurerm_mssql_server.main.fully_qualified_domain_name
    "SQL_DATABASE_NAME"                     = azurerm_mssql_database.main.name
    "KEY_VAULT_URL"                         = azurerm_key_vault.main.vault_uri
  }

  # Ignore ALL Azure-managed settings that cause drift
  lifecycle {
    ignore_changes = [
      app_settings,  # Ignore ALL app_settings changes
      site_config,   # Ignore ALL site_config changes
      tags           # Ignore ALL tag changes
    ]
  }

  depends_on = [
    azurerm_cognitive_account.openai,
    azurerm_resource_group.main,
    azurerm_application_insights.main,
    azurerm_key_vault.main
  ]
}

# Key Vault Access Policy for Function App
resource "azurerm_key_vault_access_policy" "function_access" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_function_app.proxy.identity[0].principal_id

  secret_permissions = ["Get"]
  
  depends_on = [azurerm_linux_function_app.proxy]
}
