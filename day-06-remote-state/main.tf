# Day 6: Remote State and Collaboration - Main Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Configure remote backend for state management
  # backend "s3" {
  #   bucket         = "my-terraform-state"
  #   key            = "day6/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Course       = "Terraform30Days"
      Day          = "Day6"
      Environment  = var.environment
      ManagedBy    = "Terraform"
      RemoteState  = true
    }
  }
}

# Create S3 backend bucket
resource "aws_s3_bucket" "terraform_state" {
  bucket = "day6-terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name    = "Terraform State Bucket"
    Purpose = "Store Terraform state files for collaboration"
  }
}

# Enable versioning for state recovery
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable MFA delete for additional security (optional)
resource "aws_s3_bucket_versioning" "terraform_state_mfa" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"  # Set to "Enabled" if MFA is required
  }
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "day6-terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  # Enable point-in-time recovery
  point_in_time_recovery_specification {
    enabled = true
  }

  tags = {
    Name    = "Terraform State Locks"
    Purpose = "Prevent concurrent state modifications"
  }
}

# IAM role for Terraform execution
resource "aws_iam_role" "terraform_role" {
  name = "day6-terraform-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
      }
    ]
  })

  tags = {
    Purpose = "Terraform execution"
  }
}

# IAM policy for S3 state access
resource "aws_iam_role_policy" "terraform_s3_policy" {
  name = "day6-terraform-s3-policy"
  role = aws_iam_role.terraform_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketVersioning"
        ]
        Resource = aws_s3_bucket.terraform_state.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "${aws_s3_bucket.terraform_state.arn}/*"
      }
    ]
  })
}

# IAM policy for DynamoDB locking
resource "aws_iam_role_policy" "terraform_dynamodb_policy" {
  name = "day6-terraform-dynamodb-policy"
  role = aws_iam_role.terraform_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = aws_dynamodb_table.terraform_locks.arn
      }
    ]
  })
}

# Get current account info
data "aws_caller_identity" "current" {}

# Create sample infrastructure to demonstrate remote state
resource "aws_sns_topic" "collaboration_demo" {
  name = "day6-collaboration-demo"

  tags = {
    Purpose = "Demonstrate remote state collaboration"
  }
}
