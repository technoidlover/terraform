# Day 18: Outputs for AWS Project Part 3 - Monitoring, Logging, Security

# S3 Buckets
output "app_assets_bucket_name" {
  description = "Name of the application assets S3 bucket"
  value       = aws_s3_bucket.app_assets.id
}

output "app_assets_bucket_arn" {
  description = "ARN of the application assets S3 bucket"
  value       = aws_s3_bucket.app_assets.arn
}

output "logs_bucket_name" {
  description = "Name of the logs S3 bucket"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "ARN of the logs S3 bucket"
  value       = aws_s3_bucket.logs.arn
}

output "terraform_state_bucket_name" {
  description = "Name of the Terraform state S3 bucket"
  value       = aws_s3_bucket.terraform_state.id
}

output "terraform_state_bucket_arn" {
  description = "ARN of the Terraform state S3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

# DynamoDB
output "terraform_locks_table_name" {
  description = "Name of the Terraform state locks DynamoDB table"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "terraform_locks_table_arn" {
  description = "ARN of the Terraform state locks DynamoDB table"
  value       = aws_dynamodb_table.terraform_locks.arn
}

# CloudTrail
output "cloudtrail_name" {
  description = "Name of the CloudTrail"
  value       = aws_cloudtrail.main.name
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail"
  value       = aws_cloudtrail.main.arn
}

# CloudWatch
output "app_log_group_name" {
  description = "Name of the application CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.app.name
}

output "dashboard_url" {
  description = "URL to CloudWatch Dashboard"
  value       = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${aws_cloudwatch_dashboard.main.dashboard_name}"
}

# SNS Topic
output "alarm_topic_arn" {
  description = "ARN of the SNS topic for alarm notifications"
  value       = aws_sns_topic.alarms.arn
}

# KMS Keys
output "cloudtrail_kms_key_id" {
  description = "KMS key ID for CloudTrail"
  value       = aws_kms_key.cloudtrail.key_id
}

output "cloudwatch_kms_key_id" {
  description = "KMS key ID for CloudWatch"
  value       = aws_kms_key.cloudwatch.key_id
}

# IAM Policy
output "s3_access_policy_arn" {
  description = "ARN of the S3 access policy"
  value       = aws_iam_policy.s3_access.arn
}

# Terraform Backend Configuration
output "terraform_backend_config" {
  description = "Terraform backend configuration for remote state"
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    key            = "terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
    encrypt        = true
  }
}
