# Azure Configuration
subid                       = "3e94a190-4d5a-46cb-ba0f-da01eb33d75d"
location                    = "eastus2"
environment                 = "dev"

# Resource Group and Naming
resource_group_name         = "rg-lorefieus"
storage_account_name        = "lorestorage"
function_app_name           = "func-lore"
service_plan_name           = "splan-lore"
key_vault_name              = "kv-lorefieus"
sql_server_name             = "sql-lore"
sql_database_name           = "db-user1"
openai_account_name         = "cogsvc-lorefieus"

# SQL Server Configuration
sql_admin_username          = "sqladmin"
sql_admin_password          = "M33pl3It!"
sql_entra_admin_login       = "bloblore"
sql_entra_admin_object_id   = "17ff502d-2d4b-47c3-abf2-058a79829af6"
sql_entra_admin_tenant_id   = "f0fc66d5-e40c-49f8-b32f-a9b41d633187"

# Development Configuration
dev_ip_address              = "76.105.233.235"

# Infrastructure Storage Configuration (External)
infrastructure_storage_account = "loreinfrastorage"
infrastructure_resource_group  = "rg-loreinfra"
infrastructure_container_name  = "dev"
walmart_dataset_filename       = "walmart-product-with-embeddings-dataset-usa.csv"
