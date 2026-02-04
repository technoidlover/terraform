# Day 21: Outputs for Azure Project Part 1

output "resource_group_created" {
  description = "Azure resource group created"
  value       = "Resource group for centralized management"
}

output "virtual_machines_deployed" {
  description = "Virtual machines deployed"
  value       = "Linux VMs with SSH key authentication"
}

output "networking_configured" {
  description = "Network infrastructure"
  value       = "VNet, subnet, and NSG configured"
}

output "security_configured" {
  description = "Security features"
  value       = "Key Vault, managed encryption, and firewall rules"
}
