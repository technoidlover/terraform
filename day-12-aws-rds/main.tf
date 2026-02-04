# Day 12: AWS RDS - Main Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Course = "Terraform30Days"
      Day    = "Day12"
    }
  }
}

provider "random" {}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "day12-vpc"
  }
}

# Database Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "day12-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "day12-db-subnet-group"
  }
}

# Private subnets for RDS
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "day12-private-subnet-${count.index + 1}"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "day12-rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day12-rds-sg"
  }
}

# Generate random password for RDS
resource "random_password" "rds" {
  length  = 16
  special = true
}

# RDS MySQL Instance
resource "aws_db_instance" "mysql" {
  count                       = var.enable_mysql ? 1 : 0
  identifier                  = var.mysql_identifier
  engine                      = "mysql"
  engine_version              = var.mysql_engine_version
  instance_class              = var.mysql_instance_class
  allocated_storage            = var.mysql_allocated_storage
  storage_type                = "gp3"
  db_name                     = var.mysql_db_name
  username                    = var.mysql_username
  password                    = random_password.rds.result
  db_subnet_group_name        = aws_db_subnet_group.main.name
  vpc_security_group_ids      = [aws_security_group.rds.id]
  parameter_group_name        = aws_db_parameter_group.mysql[0].name
  skip_final_snapshot         = !var.production_environment
  final_snapshot_identifier   = var.production_environment ? "${var.mysql_identifier}-final-snapshot" : null
  backup_retention_period     = var.production_environment ? 30 : 7
  backup_window               = "03:00-04:00"
  maintenance_window          = "mon:04:00-mon:05:00"
  multi_az                    = var.production_environment
  publicly_accessible         = var.publicly_accessible

  tags = {
    Name = "day12-mysql"
  }
}

# DB Parameter Group for MySQL
resource "aws_db_parameter_group" "mysql" {
  count  = var.enable_mysql ? 1 : 0
  family = "mysql8.0"
  name   = "day12-mysql-params"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "max_connections"
    value = "1000"
  }

  tags = {
    Name = "day12-mysql-params"
  }
}

# RDS PostgreSQL Instance
resource "aws_db_instance" "postgresql" {
  count                      = var.enable_postgresql ? 1 : 0
  identifier                 = var.postgresql_identifier
  engine                     = "postgres"
  engine_version             = var.postgresql_engine_version
  instance_class             = var.postgresql_instance_class
  allocated_storage          = var.postgresql_allocated_storage
  storage_type               = "gp3"
  db_name                    = var.postgresql_db_name
  username                   = var.postgresql_username
  password                   = random_password.rds.result
  db_subnet_group_name       = aws_db_subnet_group.main.name
  vpc_security_group_ids     = [aws_security_group.rds.id]
  skip_final_snapshot        = !var.production_environment
  final_snapshot_identifier  = var.production_environment ? "${var.postgresql_identifier}-final-snapshot" : null
  backup_retention_period    = var.production_environment ? 30 : 7
  multi_az                   = var.production_environment
  publicly_accessible        = var.publicly_accessible

  tags = {
    Name = "day12-postgresql"
  }
}

# CloudWatch Alarms for CPU
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  for_each = merge(
    var.enable_mysql ? { mysql = aws_db_instance.mysql[0] } : {},
    var.enable_postgresql ? { postgresql = aws_db_instance.postgresql[0] } : {}
  )

  alarm_name          = "${each.value.identifier}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    DBInstanceIdentifier = each.value.identifier
  }

  tags = {
    Name = "${each.value.identifier}-cpu-alarm"
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}
