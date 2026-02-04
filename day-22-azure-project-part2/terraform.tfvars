# Day 22: Terraform Variables - Azure Load Balancer and Database

subscription_id                = "YOUR_SUBSCRIPTION_ID"
location                       = "East US"
app_name                       = "my-app"
environment                    = "dev"
resource_group_name            = "my-app-rg"
db_admin_username              = "dbadmin"
db_admin_password              = "ChangeMe@123456"
db_sku_name                    = "B_Standard_B2s"
backup_retention_days          = 7
enable_geo_redundant_backup    = false
log_retention_days             = 30
alert_email                    = "admin@example.com"
