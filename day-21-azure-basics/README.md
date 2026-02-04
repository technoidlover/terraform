# Day 21: Azure Basics

Introduction to Microsoft Azure and Terraform provider configuration.

## Key Topics

1. Azure Provider Setup
2. Resource Groups
3. Subscriptions
4. Service Principals
5. Authentication Methods

## Provider Configuration

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
}
```

## Resource Group

```hcl
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg"
  location = var.azure_location

  tags = {
    Environment = var.environment
  }
}
```

## Service Principal

```bash
# Create service principal
az ad sp create-for-rbac --name terraform --role Contributor

# Output will contain:
# appId (client_id)
# password (client_secret)
# tenant
```

## Authentication

```bash
# Using environment variables
export ARM_SUBSCRIPTION_ID="..."
export ARM_CLIENT_ID="..."
export ARM_CLIENT_SECRET="..."
export ARM_TENANT_ID="..."

# Or using service principal file
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
```

## Lab: Azure Setup

1. Create service principal
2. Configure provider
3. Create resource group
4. Deploy test resource

---

Estimated Time: 2-3 hours
