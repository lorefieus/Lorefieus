# Resource Group Configuration
resource_group_name          = "rg-dev-lore"
location                     = "eastus2"
environment                  = "dev"

# SQL Configuration (Entra ID only)
sql_server_name              = "sql-dev-lore"
sql_database_name            = "db-user1"

# Entra ID Admin (replace with your actual values)
sql_entra_admin_login       = "bloblore"
sql_entra_admin_object_id   = "17ff502d-2d4b-47c3-abf2-058a79829af6"

# Azure OpenAI
openai_account_name          = "openai-dev-lore"

# Function App
function_app_name            = "func-dev-lore"
service_plan_name            = "plan-dev-lore"

# Storage
storage_account_name         = "storageloredev"
key_vault_name               = "kv-dev-lore"

# Network (optional - replace with your IP)
dev_ip_address              = "76.105.233.235"