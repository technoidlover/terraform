# Day 14: AWS Load Balancer and Auto Scaling - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 2

  validation {
    condition     = var.min_size >= 1 && var.min_size <= 10
    error_message = "Min size must be between 1 and 10."
  }
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 4

  validation {
    condition     = var.max_size >= 1 && var.max_size <= 10
    error_message = "Max size must be between 1 and 10."
  }
}

variable "desired_capacity" {
  description = "Desired ASG capacity"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_capacity >= 1 && var.desired_capacity <= 10
    error_message = "Desired capacity must be between 1 and 10."
  }
}
