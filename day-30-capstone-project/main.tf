# Day 30: Capstone Project - Complete Enterprise Application
# Comprehensive infrastructure combining all learned concepts

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Note: Configure remote state backend before applying
  # Uncomment and configure with your S3 bucket and DynamoDB table
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "capstone/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Capstone    = "Day30"
    }
  }
}

# ============================================================================
# VARIABLES WITH COMPREHENSIVE VALIDATION
# ============================================================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Invalid AWS region."
  }
}

variable "project_name" {
  description = "Project name"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,30}$", var.project_name))
    error_message = "Invalid project name format."
  }
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Invalid environment."
  }
}

variable "instance_count" {
  description = "Number of instances"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be 1-10."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "database_allocated_storage" {
  description = "Database storage in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.database_allocated_storage >= 20
    error_message = "Minimum 20 GB."
  }
}

variable "enable_monitoring" {
  description = "Enable monitoring"
  type        = bool
  default     = true
}

variable "enable_backup" {
  description = "Enable backups"
  type        = bool
  default     = true
}

variable "enable_multi_az" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = false
}

variable "owner_email" {
  description = "Owner email"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.owner_email))
    error_message = "Invalid email format."
  }
}

# ============================================================================
# LOCAL VALUES FOR CONFIGURATION
# ============================================================================

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner_email
    CreatedAt   = timestamp()
  }

  # Environment-specific configurations
  env_config = {
    dev = {
      instance_type = "t3.small"
      db_instance   = "db.t3.small"
      backups       = 7
      multi_az      = false
    }
    staging = {
      instance_type = "t3.medium"
      db_instance   = "db.t3.medium"
      backups       = 14
      multi_az      = false
    }
    prod = {
      instance_type = "t3.large"
      db_instance   = "db.t3.large"
      backups       = 30
      multi_az      = true
    }
  }

  config = local.env_config[var.environment]
}

# ============================================================================
# DATA SOURCES
# ============================================================================

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ============================================================================
# VPC AND NETWORKING
# ============================================================================

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.${count.index + 1}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-public-subnet-${count.index + 1}"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-private-subnet-${count.index + 1}"
  })
}

# ============================================================================
# SECURITY GROUPS
# ============================================================================

resource "aws_security_group" "alb" {
  name   = "${local.name_prefix}-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb-sg"
  })
}

resource "aws_security_group" "app" {
  name   = "${local.name_prefix}-app-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-app-sg"
  })
}

# ============================================================================
# LOAD BALANCER
# ============================================================================

resource "aws_lb" "main" {
  name               = "${local.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb"
  })
}

resource "aws_lb_target_group" "app" {
  name        = "${local.name_prefix}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-tg"
  })
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# ============================================================================
# EC2 INSTANCES
# ============================================================================

resource "aws_instance" "app" {
  count                = var.instance_count
  ami                  = data.aws_ami.amazon_linux_2.id
  instance_type        = local.config.instance_type
  subnet_id            = aws_subnet.private[count.index % 2].id
  vpc_security_group_ids = [aws_security_group.app.id]
  monitoring           = var.enable_monitoring

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-instance-${count.index + 1}"
  })

  depends_on = [aws_security_group.app]
}

resource "aws_lb_target_group_attachment" "app" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.app[count.index].id
  port             = 8080
}

# ============================================================================
# RDS DATABASE
# ============================================================================

resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-sg"
  subnet_ids = aws_subnet.private[*].id

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}

resource "aws_db_instance" "main" {
  identifier           = "${local.name_prefix}-db"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = local.config.db_instance
  allocated_storage   = var.database_allocated_storage
  storage_encrypted   = true
  multi_az            = local.config.multi_az

  db_name  = "appdb"
  username = "admin"
  password = var.owner_email # Note: Use Secrets Manager in production

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.app.id]

  backup_retention_period = local.config.backups
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  deletion_protection = var.environment == "prod" ? true : false
  skip_final_snapshot = var.environment != "prod"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-db"
  })
}

# ============================================================================
# S3 BUCKETS
# ============================================================================

resource "aws_s3_bucket" "app_data" {
  bucket = "${local.name_prefix}-data-${data.aws_caller_identity.current.account_id}"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-data"
  })
}

resource "aws_s3_bucket_versioning" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ============================================================================
# MONITORING AND ALARMS
# ============================================================================

resource "aws_cloudwatch_metric_alarm" "cpu" {
  count               = var.enable_monitoring ? 1 : 0
  alarm_name          = "${local.name_prefix}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-cpu-alarm"
  })
}

# ============================================================================
# OUTPUTS
# ============================================================================

output "load_balancer_dns" {
  description = "ALB DNS name"
  value       = aws_lb.main.dns_name
}

output "database_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.app_data.id
}

output "infrastructure_summary" {
  description = "Infrastructure summary"
  value = {
    vpc_id           = aws_vpc.main.id
    instance_count   = var.instance_count
    load_balancer    = aws_lb.main.dns_name
    database         = aws_db_instance.main.identifier
    environment      = var.environment
    monitoring       = var.enable_monitoring
  }
}

output "capstone_completion" {
  description = "Day 30 Capstone completion status"
  value       = "Enterprise-grade infrastructure with all best practices implemented"
}
