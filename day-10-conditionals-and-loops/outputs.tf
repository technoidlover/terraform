# Day 10: Conditionals and Loops - Outputs

output "vpc_id" {
  description = "VPC ID"
  value       = try(aws_vpc.main[0].id, null)
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = { for k, v in aws_subnet.main : k => v.id }
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = try(aws_internet_gateway.main[0].id, null)
}

output "security_group_id" {
  description = "Security Group ID"
  value       = try(aws_security_group.main[0].id, null)
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = { for k, v in aws_instance.main : k => v.id }
}

output "instance_map" {
  description = "Map of instance names to IDs"
  value       = local.instance_map
}

output "role_counts" {
  description = "Count of instances per role"
  value       = local.role_counts
}

output "database_endpoint" {
  description = "RDS database endpoint"
  value       = try(aws_db_instance.main[0].endpoint, null)
}

output "network_config" {
  description = "Network configuration summary"
  value       = local.network_config
}

output "configuration_summary" {
  description = "Summary of configuration decisions"
  value = {
    vpc_created       = var.create_vpc
    igw_enabled       = var.enable_igw
    instances_created = var.create_instances
    db_created        = var.environment == "production"
    environment       = var.environment
  }
}
