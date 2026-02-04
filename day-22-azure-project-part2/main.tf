# Day 22: Azure Project Part 2 - Load Balancer, Database, and Monitoring
# Creates Azure Load Balancer, Database, and comprehensive monitoring

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Load Balancer
# Distributes traffic across backend pool
resource "azurerm_lb" "lb" {
  name                = "${var.app_name}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_public_ip.lb_pip]
}

# Public IP for Load Balancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "${var.app_name}-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"

  tags = {
    environment = var.environment
    app         = var.app_name
  }
}

# Backend Address Pool
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "BackendPool"

  depends_on = [azurerm_lb.lb]
}

# Health Probe
resource "azurerm_lb_probe" "health_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "http-probe"
  port            = 8080
  protocol        = "Http"
  request_path    = "/health"

  depends_on = [azurerm_lb.lb]
}

# Load Balancer Rule
resource "azurerm_lb_rule" "http_rule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 8080
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.health_probe.id
  load_distribution              = "SourceIP"
  idle_timeout_in_minutes        = 15
  enable_floating_ip             = false

  depends_on = [azurerm_lb.lb, azurerm_lb_backend_address_pool.backend_pool, azurerm_lb_probe.health_probe]
}

# Azure Database for MySQL
# Managed relational database
resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "${var.app_name}-mysql-${random_string.db_suffix.result}"
  location               = var.location
  resource_group_name    = var.resource_group_name
  admin_login            = var.db_admin_username
  admin_password         = var.db_admin_password
  sku_name               = var.db_sku_name
  version                = "8.0"
  backup_retention_days  = var.backup_retention_days
  geo_redundant_backup_enabled = var.enable_geo_redundant_backup

  storage {
    iops    = 360
    size_gb = 20
  }

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  maintenance_window {
    day_of_week = 0
    start_hour  = 0
    start_minute = 0
  }

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_resource_group.rg]
}

# Random suffix for unique DB name
resource "random_string" "db_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Database on MySQL Server
resource "azurerm_mysql_flexible_database" "app_db" {
  name                = "app_database"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"

  depends_on = [azurerm_mysql_flexible_server.mysql]
}

# Application Insights for monitoring
resource "azurerm_application_insights" "ai" {
  name                = "${var.app_name}-ai"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  retention_in_days   = var.log_retention_days

  tags = {
    environment = var.environment
    app         = var.app_name
  }
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.app_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days

  tags = {
    environment = var.environment
    app         = var.app_name
  }
}

# Metric Alert for High CPU
resource "azurerm_monitor_metric_alert" "high_cpu" {
  name                = "${var.app_name}-high-cpu"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_lb.lb.id]
  description         = "Alert when CPU is high"
  window_size         = "PT5M"
  frequency           = "PT1M"
  severity            = 3

  criteria {
    metric_namespace = "Microsoft.Network/loadBalancers"
    metric_name      = "BytesSentCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1000000000
  }

  action {
    action_group_id = azurerm_monitor_action_group.ag.id
  }

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_lb.lb, azurerm_monitor_action_group.ag]
}

# Monitor Action Group for alerts
resource "azurerm_monitor_action_group" "ag" {
  name                = "${var.app_name}-action-group"
  resource_group_name = var.resource_group_name
  short_name          = "AppAG"

  email_receiver {
    name           = "sendtoadmin"
    email_address  = var.alert_email
    use_common_alert_schema = true
  }

  tags = {
    environment = var.environment
    app         = var.app_name
  }
}

# Placeholder for resource group (referenced from Day 21)
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    app         = var.app_name
  }
}

# Input Variables
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-app"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "resource_group_name" {
  description = "Resource group name (from Day 21)"
  type        = string
}

variable "db_admin_username" {
  description = "Database admin username"
  type        = string
  default     = "dbadmin"
}

variable "db_admin_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "db_sku_name" {
  description = "Database SKU"
  type        = string
  default     = "B_Standard_B2s"
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 35
    error_message = "Must be 1-35 days."
  }
}

variable "enable_geo_redundant_backup" {
  description = "Enable geo-redundant backups"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "Log retention days"
  type        = number
  default     = 30
}

variable "alert_email" {
  description = "Alert email"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must be valid email."
  }
}

# Outputs
output "load_balancer_ip" {
  description = "Load balancer public IP"
  value       = azurerm_public_ip.lb_pip.ip_address
}

output "load_balancer_url" {
  description = "Load balancer URL"
  value       = "http://${azurerm_public_ip.lb_pip.ip_address}"
}

output "mysql_server_id" {
  description = "MySQL server ID"
  value       = azurerm_mysql_flexible_server.mysql.id
}

output "mysql_fqdn" {
  description = "MySQL FQDN"
  value       = azurerm_mysql_flexible_server.mysql.fqdn
}

output "app_insights_instrumentation_key" {
  description = "Application Insights key"
  value       = azurerm_application_insights.ai.instrumentation_key
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = azurerm_log_analytics_workspace.law.id
}
