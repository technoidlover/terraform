# Day 7: Terraform Functions - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "Day7Functions"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 3
}

variable "allowed_ports" {
  description = "Allowed inbound ports"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "allowed_cidr" {
  description = "Allowed CIDR block"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags_string" {
  description = "Tags as comma-separated string"
  type        = string
  default     = "terraform,demo,functions"
}

variable "base_tags" {
  description = "Base tags to apply"
  type        = map(string)
  default = {
    Course = "Terraform30Days"
  }
}
