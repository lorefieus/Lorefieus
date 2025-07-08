# Subscription and Resource Group
variable "subid" {
  description = "Azure subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-lorefieus"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# SQL Server Configuration
variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
  default     = "sql-lore"
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
  type        = string
  default     = "db-user1"
}

# SQL Server Entra ID Admin Configuration
variable "sql_entra_admin_login" {
  description = "Entra ID admin login name for SQL Server"
  type        = string
}

variable "sql_entra_admin_object_id" {
  description = "Entra ID admin object ID for SQL Server"
  type        = string
}

variable "sql_entra_admin_tenant_id" {
  description = "Entra ID admin tenant ID for SQL Server (optional, defaults to current tenant)"
  type        = string
  default     = null
}

# Azure OpenAI Configuration
variable "openai_account_name" {
  description = "Name of the Azure OpenAI account"
  type        = string
  default     = "openai-lore"
}

# Function App Configuration
variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
  default     = "func-lore"
}

variable "service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
  default     = "plan-lore"
}

# Storage Account Configuration
variable "storage_account_name" {
  description = "Name of the storage account for Function App"
  type        = string
  default     = "lorestorage"
}

# Key Vault Configuration
variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
  default     = "kv-lore"
}

# Infrastructure Storage Account (Existing)
variable "infrastructure_storage_account" {
  description = "Name of the existing infrastructure storage account"
  type        = string
  default     = "loreinfrastorage"
}

variable "infrastructure_resource_group" {
  description = "Resource group name of the existing infrastructure storage account"
  type        = string
  default     = "rg-loreinfra"
}

variable "infrastructure_container_name" {
  description = "Container name in the infrastructure storage account"
  type        = string
  default     = "dev"
}

# Dataset Configuration (for manual reference)
variable "walmart_dataset_filename" {
  description = "Filename of the Walmart dataset in blob storage"
  type        = string
  default     = "walmart-product-with-embeddings-dataset-usa.csv"
}

# Network Configuration
variable "dev_ip_address" {
  description = "Developer IP address for SQL Server firewall (optional)"
  type        = string
  default     = null
}
