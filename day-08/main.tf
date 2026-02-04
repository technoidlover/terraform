# Input Variables Examples
# Vi du Bien dau vao

terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# String variable
# Bien chuoi
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

# Number variable
# Bien so
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count > 0 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10"
  }
}

# Boolean variable
# Bien boolean
variable "enable_monitoring" {
  description = "Enable monitoring for resources"
  type        = bool
  default     = true
}

# List variable
# Bien danh sach
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Map variable
# Bien map
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Project     = "Terraform Learning"
    ManagedBy   = "Terraform"
    Environment = "Development"
  }
}

# Object variable
# Bien object
variable "server_config" {
  description = "Server configuration object"
  type = object({
    name     = string
    port     = number
    protocol = string
  })
  default = {
    name     = "web-server"
    port     = 8080
    protocol = "http"
  }
}

# Sensitive variable
# Bien nhay cam
variable "api_key" {
  description = "API key for external service"
  type        = string
  sensitive   = true
  default     = "placeholder-key"
}

# Using variables in resources
# Su dung bien trong cac resource
resource "local_file" "config" {
  filename = "${path.module}/${var.environment}-config.txt"
  content  = <<-EOT
    Configuration File
    File cau hinh
    ==================
    
    Environment: ${var.environment}
    Moi truong: ${var.environment}
    
    Instance Count: ${var.instance_count}
    So Instance: ${var.instance_count}
    
    Monitoring Enabled: ${var.enable_monitoring}
    Bat Monitoring: ${var.enable_monitoring}
    
    Availability Zones:
    Cac vung Kha dung:
    ${join(", ", var.availability_zones)}
    
    Server Name: ${var.server_config.name}
    Ten May chu: ${var.server_config.name}
    
    Server Port: ${var.server_config.port}
    Cong May chu: ${var.server_config.port}
    
    Tags:
    ${jsonencode(var.tags)}
  EOT
}

# Output values to verify variables
# Gia tri dau ra de xac minh cac bien
output "environment_name" {
  value = var.environment
}

output "total_instances" {
  value = var.instance_count
}

output "monitoring_status" {
  value = var.enable_monitoring ? "Enabled" : "Disabled"
}
