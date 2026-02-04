# Day 9: Workspaces - Variables

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

variable "allowed_cidr" {
  description = "Allowed CIDR for inbound traffic"
  type        = string
  default     = "0.0.0.0/0"
}
