# Day 5: Modules and Code Reusability - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "day5-project"
}

variable "vpc_primary_cidr" {
  description = "CIDR for primary VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_secondary_cidr" {
  description = "CIDR for secondary VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidrs_primary" {
  description = "Subnet CIDRs for primary VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet_cidrs_secondary" {
  description = "Subnet CIDRs for secondary VPC"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "allowed_cidr" {
  description = "CIDR block for inbound traffic"
  type        = string
  default     = "0.0.0.0/0"
}

variable "enable_web_servers" {
  description = "Enable web server deployment"
  type        = bool
  default     = true
}

variable "web_server_count" {
  description = "Number of web servers"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
