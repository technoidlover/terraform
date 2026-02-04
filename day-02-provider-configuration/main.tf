# Day 2: Provider Configuration - Main Configuration
# This configuration demonstrates multiple provider setup and authentication methods

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary AWS Region Provider
provider "aws" {
  alias  = "primary"
  region = var.primary_region

  default_tags {
    tags = {
      Course      = "Terraform30Days"
      Day         = "Day2"
      Environment = var.environment
      CreatedBy   = "Terraform"
    }
  }
}

# Secondary AWS Region Provider
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  default_tags {
    tags = {
      Course      = "Terraform30Days"
      Day         = "Day2"
      Environment = var.environment
      CreatedBy   = "Terraform"
    }
  }
}

# Data source to get current AWS account information
data "aws_caller_identity" "primary" {
  provider = aws.primary
}

data "aws_caller_identity" "secondary" {
  provider = aws.secondary
}

# S3 bucket in primary region
resource "aws_s3_bucket" "primary" {
  provider = aws.primary
  bucket   = "day2-bucket-primary-${data.aws_caller_identity.primary.account_id}"

  tags = {
    Region = var.primary_region
    Name   = "Primary Region Bucket"
  }
}

# S3 bucket in secondary region
resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary
  bucket   = "day2-bucket-secondary-${data.aws_caller_identity.secondary.account_id}"

  tags = {
    Region = var.secondary_region
    Name   = "Secondary Region Bucket"
  }
}

# Enable versioning on primary bucket
resource "aws_s3_bucket_versioning" "primary" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable versioning on secondary bucket
resource "aws_s3_bucket_versioning" "secondary" {
  provider = aws.secondary
  bucket   = aws_s3_bucket.secondary.id

  versioning_configuration {
    status = "Enabled"
  }
}

# VPC in primary region
resource "aws_vpc" "primary" {
  provider           = aws.primary
  cidr_block         = var.vpc_cidr_primary
  enable_dns_support = true

  tags = {
    Name   = "vpc-primary"
    Region = var.primary_region
  }
}

# VPC in secondary region
resource "aws_vpc" "secondary" {
  provider           = aws.secondary
  cidr_block         = var.vpc_cidr_secondary
  enable_dns_support = true

  tags = {
    Name   = "vpc-secondary"
    Region = var.secondary_region
  }
}
