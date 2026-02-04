# Day 5: Modules and Code Reusability - Outputs

output "primary_vpc_id" {
  description = "Primary VPC ID"
  value       = module.vpc_primary.vpc_id
}

output "secondary_vpc_id" {
  description = "Secondary VPC ID"
  value       = module.vpc_secondary.vpc_id
}

output "web_security_group_id" {
  description = "Web security group ID"
  value       = module.security_group_web.security_group_id
}

output "app_security_group_id" {
  description = "Application security group ID"
  value       = module.security_group_app.security_group_id
}

output "web_server_ids" {
  description = "Web server instance IDs"
  value       = try(module.web_servers[0].instance_ids, [])
}

output "modules_deployed" {
  description = "Summary of deployed modules"
  value = {
    vpcs              = 2
    security_groups   = 2
    web_servers       = var.enable_web_servers ? var.web_server_count : 0
    environment       = var.environment
  }
}
