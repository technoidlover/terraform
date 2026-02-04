# Day 16: Terraform Variables - VPC and Networking Configuration

# AWS Region
aws_region = "us-east-1"

# Project and Environment
project_name = "multi-tier-app"
environment  = "dev"

# VPC and Subnet Configuration
vpc_cidr = "10.0.0.0/16"

# Public subnets for load balancer tier
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# Private subnets for application servers
private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]

# Database subnets for RDS
database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24"]

# Allow SSH from specific IP addresses (update with your IP)
allowed_ssh_cidrs = ["0.0.0.0/0"]

# Common tags
common_tags = {
  CostCenter = "Engineering"
  Owner      = "DevOps Team"
  Terraform  = "true"
}
