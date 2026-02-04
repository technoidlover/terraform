# Day 16: Outputs for AWS Project Part 1 - VPC and Networking
# Displays important infrastructure information

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# VPC CIDR block
output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Public subnet IDs
output "public_subnet_ids" {
  description = "List of IDs for public subnets"
  value       = aws_subnet.public[*].id
}

# Private subnet IDs
output "private_subnet_ids" {
  description = "List of IDs for private subnets"
  value       = aws_subnet.private[*].id
}

# Database subnet IDs
output "database_subnet_ids" {
  description = "List of IDs for database subnets"
  value       = aws_subnet.database[*].id
}

# NAT Gateway IPs
output "nat_gateway_ips" {
  description = "List of Elastic IPs used by NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}

# Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# ALB Security Group ID
output "alb_security_group_id" {
  description = "Security group ID for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

# Application Security Group ID
output "app_security_group_id" {
  description = "Security group ID for application servers"
  value       = aws_security_group.app.id
}

# RDS Security Group ID
output "rds_security_group_id" {
  description = "Security group ID for RDS database"
  value       = aws_security_group.rds.id
}

# ElastiCache Security Group ID
output "cache_security_group_id" {
  description = "Security group ID for ElastiCache"
  value       = aws_security_group.cache.id
}

# AWS Account ID
output "aws_account_id" {
  description = "The AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

# Available Availability Zones
output "availability_zones" {
  description = "List of available AZs in the region"
  value       = data.aws_availability_zones.available.names
}

# VPC Summary
output "vpc_summary" {
  description = "Summary of VPC configuration"
  value = {
    vpc_id                = aws_vpc.main.id
    cidr_block           = aws_vpc.main.cidr_block
    public_subnets_count  = length(aws_subnet.public)
    private_subnets_count = length(aws_subnet.private)
    database_subnets_count = length(aws_subnet.database)
    nat_gateways_count    = length(aws_nat_gateway.main)
  }
}
