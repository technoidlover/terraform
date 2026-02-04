# Day 7: Terraform Functions - Main Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Course     = "Terraform30Days"
      Day        = "Day7"
      CreatedBy  = "Terraform Functions"
    }
  }
}

# Demonstrate string functions
locals {
  # String manipulation
  project_name_lower = lower(var.project_name)
  project_name_upper = upper(var.project_name)
  
  # String concatenation
  full_bucket_name = "${local.project_name_lower}-bucket"
  
  # Using join and split
  tags_list = split(",", var.tags_string)
}

# Demonstrate collection functions
locals {
  # Convert list to map
  environment_map = tomap({
    production  = "prod"
    staging     = "stage"
    development = "dev"
  })
  
  # Merge maps
  common_tags = merge(
    var.base_tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
  
  # List comprehension
  instance_names = [for i in range(var.instance_count) : "${local.project_name_lower}-instance-${i + 1}"]
}

# Demonstrate numeric functions
locals {
  # Min/Max
  min_instances = min(var.instance_count, 5)
  max_instances = max(var.instance_count, 2)
  
  # Ceil/Floor
  calculated_count = ceil(var.instance_count / 2)
}

# Create S3 bucket with generated name
resource "aws_s3_bucket" "demo" {
  bucket = "${local.full_bucket_name}-${data.aws_caller_identity.current.account_id}"

  tags = merge(
    local.common_tags,
    {
      Name = "Day 7 Demo Bucket"
    }
  )
}

# Create resources with dynamic naming
resource "aws_sns_topic" "functions_demo" {
  count = var.instance_count
  name  = "${local.project_name_lower}-topic-${count.index + 1}"

  tags = merge(
    local.common_tags,
    {
      TopicIndex = count.index + 1
    }
  )
}

# Create security group with dynamic ingress rules
resource "aws_security_group" "functions_demo" {
  name        = "${local.project_name_lower}-sg"
  description = "Security group demonstrating Terraform functions"

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.allowed_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

# Data source for account info
data "aws_caller_identity" "current" {}

# Demonstrate conditional logic
locals {
  environment_config = var.environment == "production" ? {
    backup_enabled = true
    encryption     = "AES256"
    multi_region   = true
  } : {
    backup_enabled = false
    encryption     = "none"
    multi_region   = false
  }
}
