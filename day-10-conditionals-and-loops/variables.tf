# Day 10: Conditionals and Loops - Variables

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

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "day10-project"
}

variable "create_vpc" {
  description = "Create VPC and networking resources"
  type        = bool
  default     = true
}

variable "enable_igw" {
  description = "Enable Internet Gateway"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnets" {
  description = "Subnet configuration"
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    subnet-1a = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    }
    subnet-1b = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  }
}

variable "security_group_rules" {
  description = "Security group ingress rules"
  type = map(object({
    from_port = number
    to_port   = number
    protocol  = string
    cidr_ipv4 = string
  }))
  default = {
    http = {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
    }
    https = {
      from_port = 443
      to_port   = 443
      protocol  = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
    }
    ssh = {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_ipv4 = "0.0.0.0/0"
    }
  }
}

variable "restrict_egress" {
  description = "Restrict egress traffic"
  type        = bool
  default     = false
}

variable "create_instances" {
  description = "Create EC2 instances"
  type        = bool
  default     = true
}

variable "instances" {
  description = "EC2 instance configuration"
  type = map(object({
    instance_type = string
    subnet_key    = string
    role          = string
  }))
  default = {
    web-server-1 = {
      instance_type = "t3.micro"
      subnet_key    = "subnet-1a"
      role          = "web"
    }
    app-server-1 = {
      instance_type = "t3.small"
      subnet_key    = "subnet-1b"
      role          = "app"
    }
  }
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "changeme123!"
  sensitive   = true
}
