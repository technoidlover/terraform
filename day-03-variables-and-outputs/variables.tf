# Day 3: Variables and Outputs - Variables

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d{1}$", var.aws_region))
    error_message = "Region must be a valid AWS region."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "day3-project"

  validation {
    condition     = length(var.project_name) <= 32 && can(regex("^[a-z0-9-]*$", var.project_name))
    error_message = "Project name must be 32 characters or less and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "subnet_cidrs" {
  description = "CIDR blocks for subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  validation {
    condition     = alltrue([for cidr in var.subnet_cidrs : can(cidrhost(cidr, 0))])
    error_message = "All subnet CIDRs must be valid CIDR blocks."
  }
}

variable "allowed_ports" {
  description = "Allowed inbound ports"
  type        = list(number)
  default     = [22, 80, 443]

  validation {
    condition     = alltrue([for port in var.allowed_ports : port >= 1 && port <= 65535])
    error_message = "All ports must be between 1 and 65535."
  }
}

variable "allowed_cidr" {
  description = "CIDR block allowed for inbound traffic"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.allowed_cidr, 0))
    error_message = "Allowed CIDR must be a valid CIDR block."
  }
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*\\.[a-z0-9-]*$", var.instance_type))
    error_message = "Instance type must be a valid EC2 instance type."
  }
}

variable "root_volume_type" {
  description = "Root volume type"
  type        = string
  default     = "gp3"

  validation {
    condition     = contains(["gp3", "gp2", "io1", "st1"], var.root_volume_type)
    error_message = "Volume type must be gp3, gp2, io1, or st1."
  }
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 1000
    error_message = "Volume size must be between 8 and 1000 GB."
  }
}

variable "tags" {
  description = "Additional tags to apply to resources"
  type        = map(string)
  default     = {}
}
