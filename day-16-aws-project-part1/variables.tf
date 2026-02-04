# Day 16: Variables for AWS Project Part 1 - VPC and Networking
# Defines all input variables for VPC infrastructure

# AWS Region where resources will be created
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d{1}$", var.aws_region))
    error_message = "AWS region must be a valid region format (e.g., us-east-1)."
  }
}

# Project name for naming all resources
variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
  default     = "my-app"

  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.project_name))
    error_message = "Project name must be 3-30 lowercase alphanumeric characters or hyphens."
  }
}

# Environment name (dev, staging, prod)
variable "environment" {
  description = "Environment name for resource tagging"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# VPC CIDR block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR notation."
  }
}

# Public subnet CIDR blocks
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet CIDRs must be valid CIDR notation."
  }
}

# Private subnet CIDR blocks
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All private subnet CIDRs must be valid CIDR notation."
  }
}

# Database subnet CIDR blocks
variable "database_subnet_cidrs" {
  description = "List of CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]

  validation {
    condition = alltrue([
      for cidr in var.database_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All database subnet CIDRs must be valid CIDR notation."
  }
}

# Allowed SSH CIDR blocks for security group
variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH into EC2 instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition = alltrue([
      for cidr in var.allowed_ssh_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All allowed SSH CIDRs must be valid CIDR notation."
  }
}

# Tags for all resources
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    CostCenter = "Engineering"
    Owner      = "DevOps Team"
  }
}
