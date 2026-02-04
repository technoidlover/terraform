# Day 7: Terraform Functions - Outputs

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.demo.id
}

output "topic_names" {
  description = "SNS topic names created"
  value       = aws_sns_topic.functions_demo[*].name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.functions_demo.id
}

output "instance_names" {
  description = "Generated instance names"
  value       = local.instance_names
}

output "project_name_variants" {
  description = "Project name in different cases"
  value = {
    lowercase = local.project_name_lower
    uppercase = local.project_name_upper
  }
}

output "environment_config" {
  description = "Environment-specific configuration"
  value       = local.environment_config
}

output "min_max_instances" {
  description = "Min and max instance calculations"
  value = {
    requested = var.instance_count
    minimum   = local.min_instances
    maximum   = local.max_instances
    calculated = local.calculated_count
  }
}
