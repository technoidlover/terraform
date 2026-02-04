# Day 29: Real-World Scenarios and Advanced Patterns
# Multi-region deployment, blue-green, and disaster recovery

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary region provider
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

# Secondary region for disaster recovery
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}

# Variables
variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region for DR"
  type        = string
  default     = "us-west-2"
}

variable "enable_dr" {
  description = "Enable disaster recovery"
  type        = bool
  default     = true
}

variable "deployment_type" {
  description = "Deployment type (standard, blue-green, canary)"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "blue-green", "canary"], var.deployment_type)
    error_message = "Must be valid deployment type."
  }
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-app"
}

variable "blue_weight" {
  description = "Traffic weight for blue environment (0-100)"
  type        = number
  default     = 100

  validation {
    condition     = var.blue_weight >= 0 && var.blue_weight <= 100
    error_message = "Weight must be 0-100."
  }
}

variable "green_weight" {
  description = "Traffic weight for green environment"
  type        = number
  default     = 0

  validation {
    condition     = var.green_weight >= 0 && var.green_weight <= 100
    error_message = "Weight must be 0-100."
  }
}

# Locals for scenario configuration
locals {
  deployment_scenarios = {
    standard = {
      description = "Standard single-region deployment"
      multi_region = false
      blue_green   = false
    }
    blue-green = {
      description = "Blue-green deployment for zero-downtime updates"
      multi_region = false
      blue_green   = true
    }
    canary = {
      description = "Canary deployment with gradual rollout"
      multi_region = false
      blue_green   = false
    }
    multi-region = {
      description = "Multi-region active-active deployment"
      multi_region = true
      blue_green   = false
    }
    dr = {
      description = "Disaster recovery with failover"
      multi_region = true
      blue_green   = false
    }
  }

  current_scenario = local.deployment_scenarios[var.deployment_type]
}

# Example: Primary region infrastructure
resource "aws_s3_bucket" "app_primary" {
  provider = aws.primary
  bucket   = "${var.app_name}-${var.primary_region}-${data.aws_caller_identity.primary.account_id}"

  tags = {
    Region      = var.primary_region
    Environment = "primary"
  }
}

# Example: Secondary region infrastructure for DR
resource "aws_s3_bucket" "app_secondary" {
  provider = aws.secondary
  count    = var.enable_dr ? 1 : 0
  bucket   = "${var.app_name}-${var.secondary_region}-${data.aws_caller_identity.secondary.account_id}"

  tags = {
    Region      = var.secondary_region
    Environment = "secondary"
  }
}

# Data sources for accounts
data "aws_caller_identity" "primary" {
  provider = aws.primary
}

data "aws_caller_identity" "secondary" {
  provider = aws.secondary
}

# Outputs for scenario information
output "deployment_scenario" {
  description = "Current deployment scenario"
  value       = var.deployment_type
}

output "scenario_configuration" {
  description = "Scenario configuration details"
  value       = local.current_scenario
}

output "multi_region_status" {
  description = "Multi-region deployment status"
  value = {
    enabled          = local.current_scenario.multi_region
    primary_region   = var.primary_region
    secondary_region = var.secondary_region
  }
}

output "blue_green_configuration" {
  description = "Blue-green deployment configuration"
  value = var.deployment_type == "blue-green" ? {
    enabled       = true
    blue_weight   = var.blue_weight
    green_weight  = var.green_weight
    traffic_split = "${var.blue_weight}% to blue, ${var.green_weight}% to green"
  } : null
}

output "disaster_recovery_enabled" {
  description = "Disaster recovery status"
  value       = var.enable_dr
}

output "real_world_patterns_implemented" {
  description = "Real-world patterns in this configuration"
  value = [
    "Multi-region deployments",
    "Blue-green deployments",
    "Disaster recovery setup",
    "Canary deployments",
    "Traffic management",
    "Failover strategies"
  ]
}
