# Day 2: Provider Configuration - Outputs

output "primary_account_id" {
  description = "AWS Account ID in primary region"
  value       = data.aws_caller_identity.primary.account_id
}

output "secondary_account_id" {
  description = "AWS Account ID in secondary region"
  value       = data.aws_caller_identity.secondary.account_id
}

output "primary_region" {
  description = "Primary region configured"
  value       = var.primary_region
}

output "secondary_region" {
  description = "Secondary region configured"
  value       = var.secondary_region
}

output "primary_bucket_name" {
  description = "Name of S3 bucket in primary region"
  value       = aws_s3_bucket.primary.id
}

output "secondary_bucket_name" {
  description = "Name of S3 bucket in secondary region"
  value       = aws_s3_bucket.secondary.id
}

output "primary_vpc_id" {
  description = "VPC ID in primary region"
  value       = aws_vpc.primary.id
}

output "secondary_vpc_id" {
  description = "VPC ID in secondary region"
  value       = aws_vpc.secondary.id
}

output "provider_info" {
  description = "Provider configuration summary"
  value = {
    primary_region   = var.primary_region
    secondary_region = var.secondary_region
    environment      = var.environment
    primary_bucket   = aws_s3_bucket.primary.id
    secondary_bucket = aws_s3_bucket.secondary.id
  }
}
