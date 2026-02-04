# Day 21: Azure Project Part 1 - Virtual Machines and Networking
# Creates Azure VMs, virtual networks, and security groups

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

# Resource Group
# Container for all resources
resource "azurerm_resource_group" "rg" {
  name     = "${var.app_name}-rg"
  location = var.location

  tags = {
    environment = var.environment
    app         = var.app_name
    terraform   = "true"
  }
}

# Virtual Network
# Provides network isolation and address space
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.app_name}-vnet"
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_resource_group.rg]
}

# Subnet
# Divides network into smaller segments
resource "azurerm_subnet" "subnet" {
  name                 = "${var.app_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_cidr]

  depends_on = [azurerm_virtual_network.vnet]
}

# Network Security Group
# Firewall rules for network traffic
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.app_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow SSH
  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTP
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow HTTPS
  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow application port
  security_rule {
    name                       = "AllowAppPort"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_resource_group.rg]
}

# Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [azurerm_subnet.subnet, azurerm_network_security_group.nsg]
}

# Network Interface Cards
# Connects VMs to the subnet
resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.app_name}-nic-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testConfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip[count.index].id
  }

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_subnet.subnet, azurerm_public_ip.pip]
}

# Public IP Addresses
# Enables external connectivity
resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "${var.app_name}-pip-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_resource_group.rg]
}

# Virtual Machines
# Compute resources running applications
resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.app_name}-vm-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = var.vm_size

  # Admin user configuration
  admin_username = var.admin_username

  # Disable password authentication (use SSH keys)
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  # OS disk configuration
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_encryption_set_id = azurerm_disk_encryption_set.des.id
  }

  # Source image
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  # Network interface
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  # Custom data (startup script)
  custom_data = base64encode(file("${path.module}/user_data.sh"))

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_network_interface.nic, azurerm_disk_encryption_set.des]
}

# Storage Account for VM diagnostics
resource "azurerm_storage_account" "storage" {
  name                     = "${replace(var.app_name, "-", "")}storage${random_string.storage_suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled       = true
  min_tls_version                  = "TLS1_2"

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_resource_group.rg]
}

# Random suffix for storage account
resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
}

# Key Vault for secrets management
resource "azurerm_key_vault" "kv" {
  name                        = "${var.app_name}-kv-${random_string.kv_suffix.result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Delete",
      "Get",
      "Purge",
      "Recover",
      "Update"
    ]

    secret_permissions = [
      "Delete",
      "Get",
      "List",
      "Set"
    ]
  }

  tags = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [azurerm_resource_group.rg]
}

# Random suffix for Key Vault
resource "random_string" "kv_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Key Vault secret for database password
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  value        = var.db_password
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [azurerm_key_vault.kv]
}

# Disk Encryption Set
resource "azurerm_disk_encryption_set" "des" {
  name                = "${var.app_name}-des"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.generated.id

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_resource_group.rg]
}

# Key Vault Key for encryption
resource "azurerm_key_vault_key" "generated" {
  name         = "${var.app_name}-key"
  key_vault_id = azurerm_key_vault.kv.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [azurerm_key_vault.kv]
}

# Data source for current client configuration
data "azurerm_client_config" "current" {}

# Monitor Action Group for alerts
resource "azurerm_monitor_action_group" "ag" {
  name                = "${var.app_name}-action-group"
  resource_group_name = azurerm_resource_group.rg.name
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

  depends_on = [azurerm_resource_group.rg]
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

  validation {
    condition     = contains(["East US", "West US", "Central US", "North Europe", "West Europe"], var.location)
    error_message = "Location must be a valid Azure region."
  }
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

variable "vnet_cidr" {
  description = "Virtual network CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vm_count" {
  description = "Number of VMs"
  type        = number
  default     = 2

  validation {
    condition     = var.vm_count >= 1 && var.vm_count <= 10
    error_message = "VM count must be 1-10."
  }
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
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
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "Virtual network ID"
  value       = azurerm_virtual_network.vnet.id
}

output "vm_ids" {
  description = "VM IDs"
  value       = azurerm_linux_virtual_machine.vm[*].id
}

output "vm_public_ips" {
  description = "VM public IP addresses"
  value       = azurerm_public_ip.pip[*].ip_address
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.storage.name
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.kv.id
}

output "action_group_id" {
  description = "Monitor action group ID"
  value       = azurerm_monitor_action_group.ag.id
}
