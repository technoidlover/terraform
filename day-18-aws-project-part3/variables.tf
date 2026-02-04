# Day 18: Variables for AWS Project Part 3 - Monitoring, Logging, Security

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "my-app"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "log_retention_days" {
  description = "CloudWatch Log retention in days"
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention must be a valid CloudWatch retention period."
  }
}

variable "alert_email_address" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email_address))
    error_message = "Must be a valid email address."
  }
}

variable "enable_cloudtrail" {
  description = "Enable CloudTrail logging"
  type        = bool
  default     = true
}

variable "enable_s3_encryption" {
  description = "Enable S3 bucket encryption"
  type        = bool
  default     = true
}

variable "s3_lifecycle_days" {
  description = "Days before S3 objects transition to Glacier"
  type        = number
  default     = 90

  validation {
    condition     = var.s3_lifecycle_days >= 30
    error_message = "Lifecycle transition days must be at least 30."
  }
}
