# Day 8: Meta-arguments - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "create_instances" {
  description = "Create EC2 instances"
  type        = bool
  default     = true
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "bucket_config" {
  description = "S3 bucket configuration"
  type = map(object({
    environment         = string
    enable_versioning   = bool
  }))
  default = {
    production = {
      environment       = "prod"
      enable_versioning = true
    }
    staging = {
      environment       = "stage"
      enable_versioning = true
    }
    development = {
      environment       = "dev"
      enable_versioning = false
    }
  }
}
