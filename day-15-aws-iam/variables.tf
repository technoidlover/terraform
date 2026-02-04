# Day 15: AWS IAM - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "developer_usernames" {
  description = "List of IAM user names for developers"
  type        = list(string)
  default     = ["john.doe", "jane.smith", "bob.johnson"]
}

variable "create_access_keys" {
  description = "Create access keys for users"
  type        = bool
  default     = false
}

variable "enforce_password_policy" {
  description = "Enforce account password policy"
  type        = bool
  default     = true
}
