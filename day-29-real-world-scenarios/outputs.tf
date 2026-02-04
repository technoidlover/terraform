# Day 29: Outputs for Real-World Scenarios

output "advanced_deployment_patterns" {
  description = "Advanced deployment patterns"
  value       = "Multi-region, blue-green, canary, and disaster recovery"
}

output "use_cases" {
  description = "Real-world use cases"
  value = [
    "High-availability deployments",
    "Zero-downtime updates",
    "Disaster recovery",
    "Gradual rollouts",
    "Traffic management"
  ]
}
