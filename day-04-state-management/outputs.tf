# Day 4: State Management - Outputs

output "state_bucket_id" {
  description = "ID of S3 bucket for state storage"
  value       = aws_s3_bucket.state_bucket.id
}

output "state_bucket_arn" {
  description = "ARN of S3 bucket for state storage"
  value       = aws_s3_bucket.state_bucket.arn
}

output "state_bucket_versioning_enabled" {
  description = "Whether versioning is enabled on state bucket"
  value       = aws_s3_bucket_versioning.state_bucket.versioning_configuration[0].status == "Enabled"
}

output "terraform_locks_table_name" {
  description = "Name of DynamoDB table for state locks"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "state_configuration_template" {
  description = "Terraform backend S3 configuration"
  value       = local_file.state_backend_config.filename
}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}
