# Day 25: Terraform Workspaces and Environment Separation
# Demonstrates using workspaces for managing multiple environments

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
      Workspace   = terraform.workspace
      Environment = local.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Use workspace name to determine environment
locals {
  environment = terraform.workspace
  
  # Environment-specific configurations
  env_config = {
    dev = {
      instance_type       = "t3.small"
      instance_count      = 1
      enable_monitoring   = false
      backup_retention    = 7
      multi_az            = false
      public_ip_enabled   = true
    }
    staging = {
      instance_type       = "t3.medium"
      instance_count      = 2
      enable_monitoring   = true
      backup_retention    = 14
      multi_az            = false
      public_ip_enabled   = true
    }
    prod = {
      instance_type       = "t3.large"
      instance_count      = 3
      enable_monitoring   = true
      backup_retention    = 30
      multi_az            = true
      public_ip_enabled   = false
    }
  }

  config = local.env_config[local.environment]
}

# Get latest AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# VPC for the workspace environment
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.app_name}-vpc-${local.environment}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-igw-${local.environment}"
  }
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = local.config.public_ip_enabled

  tags = {
    Name = "${var.app_name}-public-subnet-${local.environment}"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.app_name}-rt-${local.environment}"
  }
}

# Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "app" {
  name        = "${var.app_name}-sg-${local.environment}"
  vpc_id      = aws_vpc.main.id

  # Allow SSH only in non-prod
  dynamic "ingress" {
    for_each = local.environment != "prod" ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Allow HTTP in all environments
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS only in prod
  dynamic "ingress" {
    for_each = local.environment == "prod" ? [1] : []
    content {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.app_name}-sg-${local.environment}"
  }
}

# EC2 Instances
resource "aws_instance" "app" {
  count                = local.config.instance_count
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = local.config.instance_type
  subnet_id            = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.app.id]

  # Detailed monitoring for prod
  monitoring = local.config.enable_monitoring

  # Add tags
  tags = {
    Name = "${var.app_name}-instance-${local.environment}-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main, aws_security_group.app]
}

# RDS Instance (different configs per environment)
resource "aws_db_instance" "main" {
  identifier           = "${var.app_name}-db-${local.environment}"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = local.config.instance_type
  allocated_storage   = local.environment == "prod" ? 100 : 20
  storage_encrypted   = true
  multi_az            = local.config.multi_az

  username = var.db_username
  password = var.db_password

  backup_retention_period = local.config.backup_retention
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  deletion_protection = local.environment == "prod" ? true : false
  skip_final_snapshot = local.environment != "prod"

  tags = {
    Name = "${var.app_name}-rds-${local.environment}"
  }
}

# CloudWatch Alarms (only for non-dev environments)
resource "aws_cloudwatch_metric_alarm" "cpu" {
  count               = local.config.enable_monitoring ? 1 : 0
  alarm_name          = "${var.app_name}-high-cpu-${local.environment}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when CPU exceeds 80%"
  treat_missing_data  = "notBreaching"

  depends_on = [aws_instance.app]
}

# Input Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-app"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
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
  sensitive   = true
}

# Outputs
output "environment" {
  description = "Current environment"
  value       = local.environment
}

output "environment_config" {
  description = "Environment configuration"
  value       = local.config
}

output "instance_type" {
  description = "Instance type for this environment"
  value       = local.config.instance_type
}

output "instance_count" {
  description = "Number of instances"
  value       = local.config.instance_count
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "workspace_info" {
  description = "Workspace information"
  value = {
    workspace_name = terraform.workspace
    environment    = local.environment
    region         = var.aws_region
  }
}
