# Day 24: Terraform Testing and Validation
# Demonstrates validation blocks, testing strategies, and data validation

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
}

# Example 1: Variable with validation
variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# Example 2: Numeric validation with range
variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

# Example 3: List validation with length check
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 1 && length(var.availability_zones) <= 3
    error_message = "Must specify 1 to 3 availability zones."
  }
}

# Example 4: String validation with regex
variable "application_name" {
  description = "Application name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.application_name))
    error_message = "Application name must be 3-30 lowercase alphanumeric characters or hyphens."
  }
}

# Example 5: CIDR block validation
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR notation."
  }
}

# Example 6: Email validation
variable "notification_email" {
  description = "Email for notifications"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.notification_email))
    error_message = "Must be a valid email address."
  }
}

# Example 7: Complex validation with alltrue
variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)

  validation {
    condition = alltrue([
      for cidr in var.subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All subnet CIDRs must be valid CIDR notation."
  }

  validation {
    condition     = length(var.subnet_cidrs) > 0
    error_message = "Must specify at least one subnet."
  }
}

# Example 8: Resource with validation through variables
resource "aws_security_group" "validated" {
  name        = var.application_name
  description = "Security group for ${var.application_name}"

  # Example ingress rule with conditional logic
  dynamic "ingress" {
    for_each = var.environment == "prod" ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow HTTP in all environments
  dynamic "ingress" {
    for_each = [1]
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow SSH in non-prod
  dynamic "ingress" {
    for_each = var.environment != "prod" ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name        = "${var.application_name}-sg"
    Environment = var.environment
  }
}

# Example 9: Validation using locals
locals {
  # Validate configuration consistency
  environment_config = {
    dev = {
      instance_type = "t3.small"
      min_count     = 1
      max_count     = 3
    }
    staging = {
      instance_type = "t3.medium"
      min_count     = 2
      max_count     = 5
    }
    prod = {
      instance_type = "t3.large"
      min_count     = 3
      max_count     = 10
    }
  }

  # Get configuration for current environment
  current_config = local.environment_config[var.environment]

  # Validate instance count against environment limits
  instance_count_valid = var.instance_count >= local.current_config.min_count && var.instance_count <= local.current_config.max_count
}

# Example 10: Validation assertion in output
output "validation_summary" {
  description = "Summary of validations"
  value = {
    environment         = var.environment
    instance_count      = var.instance_count
    availability_zones  = var.availability_zones
    application_name    = var.application_name
    vpc_cidr            = var.vpc_cidr
    notification_email  = var.notification_email
    subnet_cidrs_count  = length(var.subnet_cidrs)
    instance_count_valid = local.instance_count_valid
  }
}

# Example 11: Precondition validation
resource "aws_instance" "validated" {
  count         = local.instance_count_valid ? var.instance_count : 0
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = local.current_config.instance_type

  lifecycle {
    # Validate configuration before applying
    precondition {
      condition     = var.instance_count <= 10
      error_message = "Cannot create more than 10 instances."
    }
  }

  tags = {
    Name        = "${var.application_name}-instance-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_security_group.validated]
}

# Get latest AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Example 12: Postcondition validation
resource "aws_security_group_rule" "validation" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.validated.id

  lifecycle {
    # Validate after resource creation
    postcondition {
      condition     = self.from_port == 80
      error_message = "Ingress rule port must be 80."
    }
  }
}

# Input variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Outputs
output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.validated.id
}

output "instances_created" {
  description = "Number of instances created"
  value       = length(aws_instance.validated)
}

output "validation_passed" {
  description = "All validations passed"
  value       = true
}
