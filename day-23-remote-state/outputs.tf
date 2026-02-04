# Day 23: Outputs for Remote State

output "remote_state_configured" {
  description = "Remote state infrastructure"
  value       = "S3 bucket, DynamoDB, KMS encryption, and CloudTrail logging"
}

output "state_management_summary" {
  description = "State management setup"
  value       = "Safe, encrypted, and audited remote state storage"
}
