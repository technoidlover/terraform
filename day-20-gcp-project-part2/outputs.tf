# Day 20: Outputs for GCP Project Part 2

output "load_balancer_configured" {
  description = "HTTP(S) load balancer created"
  value       = "Global HTTP load balancer with auto-scaling"
}

output "instance_group_manager_configured" {
  description = "Instance group with auto-scaling"
  value       = "Managed instance group configured"
}

output "monitoring_dashboard" {
  description = "Cloud Monitoring dashboard"
  value       = "Dashboard created for CPU and memory metrics"
}

output "health_checks_configured" {
  description = "Health checks for load balancer"
  value       = "HTTP health checks configured on port 8080"
}
