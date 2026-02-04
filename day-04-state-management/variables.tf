# Day 4: State Management - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "enable_state_locking" {
  description = "Enable DynamoDB state locking"
  type        = bool
  default     = true
}

variable "state_encryption_enabled" {
  description = "Enable state encryption"
  type        = bool
  default     = true
}

variable "state_versioning_enabled" {
  description = "Enable state file versioning"
  type        = bool
  default     = true
}
