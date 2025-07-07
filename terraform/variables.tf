variable "sql_entra_admin_login" {
  description = "The login name of the Azure AD administrator for SQL Server"
  type        = string
  default     = "lorefieus-sql-admin"
}

variable "sql_entra_admin_object_id" {
  description = "The object ID of the Azure AD user/group to be set as SQL Server admin"
  type        = string

}

variable "sql_entra_admin_tenant_id" {
  description = "The tenant ID for the Azure AD admin"
  type        = string
  default     = null  # Will use current tenant if not specified
}

variable "location" {
  description = "Azure region to deploy resources"
  default     = "westus3"
}

variable "subid" {
  default = "3e94a190-4d5a-46cb-ba0f-da01eb33d75d"
}

variable "resource_group_name" {
  default = "rg-lorefieus"
}

variable "storage_account_name" {
  default = "lorestorage"
}

variable "function_app_name" {
  default = "func-lore"
}

variable "service_plan_name" {
  default = "asp-openai-fn"
}

variable "key_vault_name" {
  default = "kv-lore"
}

variable "sql_server_name" {
  default = "sql-lore"
}

variable "sql_database_name" {
  default = "db-user1"
}

variable "sql_admin_username" {
  default = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL admin password"
  type        = string
  sensitive   = true
}

variable "openai_account_name" {
  default = "cogsvc-lore"
}

variable "dev_ip_address" {
  default = ""
  description = "IP Address of User outside of the Azure network"
}