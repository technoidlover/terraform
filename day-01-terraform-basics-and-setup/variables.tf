# Day 1: Terraform Configuration - Variables
# This file declares all input variables used in the configuration

# AWS Region variable
# Specifies which AWS region to deploy resources to
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"

  # Validation: Ensure it's a valid AWS region format
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d{1}$", var.aws_region))
    error_message = "AWS region must be in valid format (e.g., us-east-1)."
  }
}

# Instance Type variable
# Determines the size and capacity of the EC2 instance
variable "instance_type" {
  description = "EC2 instance type - determines compute capacity"
  type        = string
  default     = "t2.micro"

  # Validation: Ensure instance type is free tier eligible
  # t2.micro is always free tier eligible
  # t2.small is free tier eligible for first year
  validation {
    condition     = can(regex("^(t2|t3)\\.", var.instance_type))
    error_message = "Instance type must be t2 or t3 family for this learning exercise."
  }
}

# Optional: Add more variables as needed for exercises
# Example of integer variable
variable "tag_cost_center" {
  description = "Cost center code for billing and cost allocation"
  type        = string
  default     = "learning"
  sensitive   = false
}

# Optional: List variable example
# Can be used if you extend the exercise to create multiple instances
variable "enabled_features" {
  description = "Features to enable on the instance"
  type        = list(string)
  default     = ["monitoring", "backup"]

  # Validation: Ensure only valid features are specified
  validation {
    condition = alltrue([
      for feature in var.enabled_features : contains(["monitoring", "backup", "logging"], feature)
    ])
    error_message = "Features must be one of: monitoring, backup, logging."
  }
}

# Optional: Map variable example
# Useful for complex configurations
variable "instance_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default = {
    Owner      = "Learning"
    Department = "Engineering"
  }
}
