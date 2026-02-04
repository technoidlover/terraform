# Day 17: Variables for AWS Project Part 2 - Load Balancer, EC2, and Database

# AWS Region
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# Project name
variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "my-app"
}

# Environment
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# VPC CIDR (for data source lookup)
variable "vpc_cidr" {
  description = "VPC CIDR for data source"
  type        = string
  default     = "10.0.0.0/16"
}

# Public subnet CIDRs (for data source lookup)
variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Private subnet CIDRs (for data source lookup)
variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

# Database subnet CIDRs (for data source lookup)
variable "database_subnet_cidrs" {
  description = "Database subnet CIDRs"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

# Security Group IDs (in production, reference from VPC stack)
variable "alb_security_group_id" {
  description = "ALB security group ID"
  type        = string
  default     = ""
}

variable "app_security_group_id" {
  description = "Application security group ID"
  type        = string
  default     = ""
}

variable "rds_security_group_id" {
  description = "RDS security group ID"
  type        = string
  default     = ""
}

variable "cache_security_group_id" {
  description = "Cache security group ID"
  type        = string
  default     = ""
}

# Load Balancer Configuration
variable "enable_alb_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

# EC2 Configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"

  validation {
    condition     = can(regex("^t3\\.", var.instance_type)) || can(regex("^t4g\\.", var.instance_type))
    error_message = "Instance type must be t3 or t4g family."
  }
}

variable "root_volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 1000
    error_message = "Root volume size must be between 8 and 1000 GB."
  }
}

# Auto Scaling Group Configuration
variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2

  validation {
    condition     = var.min_size >= 1
    error_message = "Minimum size must be at least 1."
  }
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 6

  validation {
    condition     = var.max_size >= var.min_size
    error_message = "Maximum size must be >= minimum size."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_capacity >= 1
    error_message = "Desired capacity must be at least 1."
  }
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization for auto scaling"
  type        = number
  default     = 70

  validation {
    condition     = var.target_cpu_utilization > 0 && var.target_cpu_utilization <= 100
    error_message = "Target CPU utilization must be between 1 and 100."
  }
}

# RDS Configuration
variable "mysql_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"

  validation {
    condition     = can(regex("^8\\.", var.mysql_version))
    error_message = "MySQL version must be 8.0 or later."
  }
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.small"

  validation {
    condition     = can(regex("^db\\.t3\\.", var.db_instance_class)) || can(regex("^db\\.t4g\\.", var.db_instance_class))
    error_message = "DB instance class must be t3 or t4g family."
  }
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.db_allocated_storage >= 20 && var.db_allocated_storage <= 65536
    error_message = "Allocated storage must be between 20 and 65536 GB."
  }
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.db_name))
    error_message = "Database name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "admin"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.db_username))
    error_message = "Database username must start with a letter."
  }

  sensitive = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters."
  }
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 35
    error_message = "Backup retention must be between 1 and 35 days."
  }
}

variable "enable_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "enable_performance_insights" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for RDS"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = true
}

# ElastiCache Configuration
variable "cache_node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.micro"

  validation {
    condition     = can(regex("^cache\\.t3\\.", var.cache_node_type)) || can(regex("^cache\\.t4g\\.", var.cache_node_type))
    error_message = "Cache node type must be t3 or t4g family."
  }
}

variable "cache_num_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.cache_num_nodes >= 1 && var.cache_num_nodes <= 500
    error_message = "Number of nodes must be between 1 and 500."
  }
}

variable "redis_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"

  validation {
    condition     = can(regex("^[67]\\.", var.redis_version))
    error_message = "Redis version must be 6.x or 7.x."
  }
}

variable "cache_snapshot_retention_days" {
  description = "Redis snapshot retention in days"
  type        = number
  default     = 5

  validation {
    condition     = var.cache_snapshot_retention_days >= 0 && var.cache_snapshot_retention_days <= 35
    error_message = "Snapshot retention must be between 0 and 35 days."
  }
}
