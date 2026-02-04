# Day 9: Workspaces - Outputs

output "workspace_name" {
  description = "Current workspace name"
  value       = terraform.workspace
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = aws_subnet.main[*].id
}

output "instance_ids" {
  description = "Instance IDs"
  value       = aws_instance.main[*].id
}

output "instance_count" {
  description = "Number of instances deployed"
  value       = length(aws_instance.main)
}

output "workspace_config" {
  description = "Current workspace configuration"
  value = {
    workspace_name    = terraform.workspace
    instance_count    = local.current_workspace_config.instance_count
    instance_type     = local.current_workspace_config.instance_type
    backup_enabled    = local.current_workspace_config.enable_backup
    environment       = local.current_workspace_config.environment_name
  }
}
