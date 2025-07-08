variable "subid" {
  description = "Azure subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account for Function App"
  type        = string
}

variable "function_app_name" {
  description = "Name of the Function App"
  type        = string
}

variable "service_plan_name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
}

variable "sql_database_name" {
  description = "Name of the SQL Database"
  type        = string
}

variable "sql_admin_username" {
  description = "SQL Server administrator username"
  type        = string
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "openai_account_name" {
  description = "Name of the OpenAI Cognitive Account"
  type        = string
}

variable "sql_entra_admin_login" {
  description = "Entra ID admin login for SQL Server"
  type        = string
}

variable "sql_entra_admin_object_id" {
  description = "Entra ID admin object ID for SQL Server"
  type        = string
}

variable "sql_entra_admin_tenant_id" {
  description = "Entra ID admin tenant ID for SQL Server"
  type        = string
  default     = null
}

variable "dev_ip_address" {
  description = "Developer IP address for SQL Server firewall"
  type        = string
  default     = null
}

variable "infrastructure_storage_account" {
  description = "Name of the existing infrastructure storage account (not managed by this Terraform)"
  type        = string
  default     = "loreinfrastorage"
}

variable "infrastructure_resource_group" {
  description = "Name of the existing infrastructure resource group (not managed by this Terraform)"
  type        = string
  default     = "rg-loreinfra"
}

variable "infrastructure_container_name" {
  description = "Name of the container in the infrastructure storage account"
  type        = string
  default     = "dev"
}

variable "walmart_dataset_filename" {
  description = "Filename of the Walmart dataset in infrastructure storage"
  type        = string
  default     = "walmart-product-with-embeddings-dataset-usa.csv"
}