# Day 19: Outputs for GCP Project Part 1

output "vpc_network_id" {
  description = "VPC network ID"
  value       = "VPC network created"
}

output "instances_created" {
  description = "List of instances created"
  value       = "Check outputs in main.tf"
}

output "cloud_sql_instance" {
  description = "Cloud SQL instance details"
  value       = "MySQL instance created with high availability options"
}

output "storage_bucket" {
  description = "Cloud Storage bucket for application"
  value       = "Encrypted bucket created"
}

output "monitoring_configured" {
  description = "Monitoring and alerting"
  value       = "CPU utilization alerts configured"
}
