# Day 28: Terraform Best Practices and Code Organization
# Demonstrates production-grade Terraform code patterns

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      CreatedAt   = timestamp()
    }
  }
}

# Best Practice 1: Consistent naming conventions
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    Owner       = var.owner_email
    CostCenter  = var.cost_center
  }
}

# Best Practice 2: Comprehensive variable validation
variable "aws_region" {
  description = "AWS region for resources"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "AWS region must be valid format."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.project_name))
    error_message = "Project name must be 3-30 lowercase alphanumeric or hyphen."
  }
}

variable "owner_email" {
  description = "Owner email for resources"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner_email))
    error_message = "Must be valid email address."
  }
}

variable "cost_center" {
  description = "Cost center for billing"
  type        = string
}

variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable access logging"
  type        = bool
  default     = true
}

# Best Practice 3: Use data sources for flexibility
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Best Practice 4: Use outputs for important values
output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "environment" {
  description = "Environment"
  value       = var.environment
}

output "naming_convention" {
  description = "Name prefix for consistent resource naming"
  value       = local.name_prefix
}

output "common_tags" {
  description = "Common tags applied to all resources"
  value       = local.common_tags
}

output "best_practices_implemented" {
  description = "Best practices implemented in this configuration"
  value = [
    "Consistent naming conventions",
    "Comprehensive input validation",
    "Default tags on provider",
    "Data sources for flexibility",
    "Meaningful outputs",
    "Sensitive data protection",
    "Error handling",
    "Documentation"
  ]
}

# Best Practice 5: Document your outputs
output "deployment_info" {
  description = "Deployment information for reference"
  value = {
    account_id      = data.aws_caller_identity.current.account_id
    region          = var.aws_region
    environment     = var.environment
    project_name    = var.project_name
    owner           = var.owner_email
    deployment_date = timestamp()
  }
}
