# Day 18: AWS Project Part 3 - Monitoring, Logging, Security, and S3
# This file creates CloudWatch monitoring, CloudTrail logging, S3 buckets, and SSL certificates

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
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# S3 bucket for application static files
# Stores images, CSS, JavaScript, and other static content
resource "aws_s3_bucket" "app_assets" {
  bucket              = "${var.project_name}-assets-${data.aws_caller_identity.current.account_id}"
  object_lock_enabled = false

  tags = {
    Name = "${var.project_name}-app-assets"
  }
}

# Enable versioning for S3 bucket
resource "aws_s3_bucket_versioning" "app_assets" {
  bucket = aws_s3_bucket.app_assets.id

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.app_assets]
}

# Block all public access to assets bucket
resource "aws_s3_bucket_public_access_block" "app_assets" {
  bucket = aws_s3_bucket.app_assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.app_assets]
}

# Enable encryption for assets bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "app_assets" {
  bucket = aws_s3_bucket.app_assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  depends_on = [aws_s3_bucket.app_assets]
}

# Enable logging for assets bucket
resource "aws_s3_bucket_logging" "app_assets" {
  bucket = aws_s3_bucket.app_assets.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "assets-logs/"

  depends_on = [aws_s3_bucket.app_assets, aws_s3_bucket.logs]
}

# S3 bucket for application logs
# Stores access logs and CloudTrail logs
resource "aws_s3_bucket" "logs" {
  bucket              = "${var.project_name}-logs-${data.aws_caller_identity.current.account_id}"
  object_lock_enabled = false

  tags = {
    Name = "${var.project_name}-logs"
  }
}

# Block public access to logs bucket
resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.logs]
}

# Enable encryption for logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  depends_on = [aws_s3_bucket.logs]
}

# S3 bucket for Terraform state (for remote state configuration)
resource "aws_s3_bucket" "terraform_state" {
  bucket              = "${var.project_name}-terraform-state-${data.aws_caller_identity.current.account_id}"
  object_lock_enabled = false

  tags = {
    Name = "${var.project_name}-terraform-state"
  }
}

# Enable versioning for state bucket
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.terraform_state]
}

# Block public access to state bucket
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.terraform_state]
}

# Enable encryption for state bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }

  depends_on = [aws_s3_bucket.terraform_state]
}

# DynamoDB table for Terraform state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "${var.project_name}-terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-terraform-locks"
  }
}

# CloudTrail for API audit logging
# Logs all AWS API calls for security and compliance
resource "aws_cloudtrail" "main" {
  depends_on = [aws_s3_bucket_policy.cloudtrail]

  name                          = "${var.project_name}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn

  event_selector {
    include_management_events = true
    read_write_type           = "All"

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::*/"]
    }
  }

  tags = {
    Name = "${var.project_name}-cloudtrail"
  }
}

# S3 bucket policy for CloudTrail
resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.logs.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.logs.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket.logs]
}

# KMS key for CloudTrail encryption
resource "aws_kms_key" "cloudtrail" {
  description = "KMS key for CloudTrail encryption"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudTrail to encrypt logs"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey",
          "kms:DecryptDataKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# KMS key alias
resource "aws_kms_alias" "cloudtrail" {
  name          = "alias/${var.project_name}-cloudtrail"
  target_key_id = aws_kms_key.cloudtrail.key_id

  depends_on = [aws_kms_key.cloudtrail]
}

# CloudWatch Log Group for application logs
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/app/${var.project_name}"
  retention_in_days = var.log_retention_days

  kms_key_arn = aws_kms_key.cloudwatch.arn

  tags = {
    Name = "${var.project_name}-app-logs"
  }

  depends_on = [aws_kms_key.cloudwatch]
}

# KMS key for CloudWatch Logs encryption
resource "aws_kms_key" "cloudwatch" {
  description = "KMS key for CloudWatch Logs encryption"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${var.aws_region}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# CloudWatch Alarms for monitoring
# Alarm for high CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when CPU exceeds 80%"
  treat_missing_data  = "notBreaching"
}

# Alarm for high memory usage
resource "aws_cloudwatch_metric_alarm" "high_memory" {
  alarm_name          = "${var.project_name}-high-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "Alert when memory exceeds 80%"
  treat_missing_data  = "notBreaching"
}

# SNS Topic for alarm notifications
resource "aws_sns_topic" "alarms" {
  name              = "${var.project_name}-alarms"
  kms_master_key_id = aws_kms_key.sns.id

  tags = {
    Name = "${var.project_name}-alarms"
  }

  depends_on = [aws_kms_key.sns]
}

# KMS key for SNS encryption
resource "aws_kms_key" "sns" {
  description = "KMS key for SNS encryption"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow SNS"
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# SNS Topic Subscription for email notifications
resource "aws_sns_topic_subscription" "alarms_email" {
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alert_email_address

  depends_on = [aws_sns_topic.alarms]
}

# Subscribe alarms to SNS topic
resource "aws_cloudwatch_metric_alarm" "high_cpu_notification" {
  alarm_name          = "${var.project_name}-high-cpu-notify"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "85"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  alarm_description   = "Alert when CPU exceeds 85% with notification"
  treat_missing_data  = "notBreaching"

  depends_on = [aws_sns_topic.alarms]
}

# Data source for AWS account ID and region
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# IAM Policy for S3 bucket access
resource "aws_iam_policy" "s3_access" {
  name        = "${var.project_name}-s3-access"
  description = "Policy for accessing S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.app_assets.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.app_assets.arn
        ]
      }
    ]
  })
}

# CloudWatch Dashboard for monitoring
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime"],
            [".", "RequestCount"],
            [".", "HTTPCode_Target_2XX_Count"],
            [".", "HTTPCode_Target_4XX_Count"],
            [".", "HTTPCode_Target_5XX_Count"]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "Load Balancer Metrics"
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization"],
            [".", "DatabaseConnections"],
            [".", "ReadLatency"],
            [".", "WriteLatency"]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RDS Database Metrics"
        }
      }
    ]
  })

  depends_on = [aws_cloudwatch_log_group.app]
}
