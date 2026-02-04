# Day 17: Terraform Variables - Load Balancer, EC2, and Database

# AWS Region
aws_region = "us-east-1"

# Project and Environment
project_name = "multi-tier-app"
environment  = "dev"

# VPC and Network Configuration (from Day 16)
vpc_cidr              = "10.0.0.0/16"
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.10.0/24", "10.0.11.0/24"]
database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24"]

# ALB Configuration
enable_alb_deletion_protection = false

# EC2 Configuration
instance_type    = "t3.small"
root_volume_size = 20

# Auto Scaling Configuration
min_size              = 2
max_size              = 6
desired_capacity      = 2
target_cpu_utilization = 70

# RDS Configuration
mysql_version          = "8.0"
db_instance_class      = "db.t3.small"
db_allocated_storage   = 20
db_name                = "appdb"
db_username            = "admin"
db_password            = "ChangeMe@123456" # NEVER commit real passwords - use AWS Secrets Manager
backup_retention_days  = 7
enable_multi_az        = false
enable_performance_insights = false
enable_deletion_protection = true
skip_final_snapshot    = true

# ElastiCache Configuration
cache_node_type            = "cache.t3.micro"
cache_num_nodes            = 1
redis_version              = "7.0"
cache_snapshot_retention_days = 5
