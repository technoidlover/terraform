# Day 6: Remote State and Collaboration - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
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

variable "enable_mfa_delete" {
  description = "Enable MFA delete on state bucket"
  type        = bool
  default     = false
}

variable "terraform_team_members" {
  description = "List of team members with Terraform access"
  type        = list(string)
  default     = ["terraform-user"]
}
