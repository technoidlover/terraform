# Day 22: Outputs for Azure Project Part 2

output "load_balancer_deployed" {
  description = "Azure Load Balancer created"
  value       = "Standard tier load balancer with health probes"
}

output "database_deployed" {
  description = "Azure Database for MySQL"
  value       = "Flexible server with zone redundancy"
}

output "monitoring_configured" {
  description = "Application Insights and Log Analytics"
  value       = "Comprehensive monitoring and alerting"
}

output "infrastructure_summary" {
  description = "Infrastructure status"
  value       = "Day 22: Load Balancer, Database, and Monitoring complete"
}
