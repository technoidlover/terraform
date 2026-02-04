# Day 4: State Management - Main Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }

  # Demonstrate different state backends
  # Uncomment one of the following backends to use it
  
  # Local backend (default)
  # backend "local" {
  #   path = "terraform.tfstate"
  # }

  # S3 backend with state locking
  # backend "s3" {
  #   bucket         = "terraform-state-bucket"
  #   key            = "day4/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Course      = "Terraform30Days"
      Day         = "Day4"
      Environment = var.environment
    }
  }
}

provider "local" {}

# Create S3 bucket for state storage
resource "aws_s3_bucket" "state_bucket" {
  bucket = "day4-state-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "Terraform State Bucket"
    Purpose = "State Management"
  }
}

# Enable versioning on state bucket
resource "aws_s3_bucket_versioning" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access to state bucket
resource "aws_s3_bucket_public_access_block" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable encryption on state bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "state_bucket" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "day4-terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Locks"
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create local configuration file
resource "local_file" "state_backend_config" {
  filename = "${path.module}/backend-s3.tf"
  content  = templatefile("${path.module}/backend-template.tf.tpl", {
    bucket_name    = aws_s3_bucket.state_bucket.id
    table_name     = aws_dynamodb_table.terraform_locks.id
    region         = var.aws_region
    account_id     = data.aws_caller_identity.current.account_id
  })
}

# Test resource to demonstrate state tracking
resource "aws_sns_topic" "state_test" {
  name = "day4-state-test-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "State Test Topic"
  }
}
