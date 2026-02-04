# Day 8: Meta-arguments - Outputs

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.count_demo[*].id
}

output "instance_private_ips" {
  description = "EC2 instance private IPs"
  value       = aws_instance.count_demo[*].private_ip
}

output "bucket_names" {
  description = "S3 bucket names"
  value       = { for k, v in aws_s3_bucket.for_each_demo : k => v.id }
}

output "bucket_versioning_status" {
  description = "Versioning status for each bucket"
  value = {
    for k, v in aws_s3_bucket_versioning.for_each_demo :
    k => v.versioning_configuration[0].status
  }
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.dependencies.id
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = aws_sns_topic.lifecycle_demo.arn
}

output "meta_arguments_summary" {
  description = "Summary of meta-arguments used"
  value = {
    count_instances = length(aws_instance.count_demo)
    for_each_buckets = length(aws_s3_bucket.for_each_demo)
    depends_on_configured = true
    lifecycle_configured = true
    timeouts_configured = true
  }
}
