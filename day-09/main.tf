# Output Values Examples
# Vi du Gia tri dau ra

terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Variables for demonstration
# Bien de minh hoa
variable "project_name" {
  type    = string
  default = "terraform-outputs-demo"
}

# Resources to demonstrate outputs
# Resources de minh hoa outputs
resource "random_pet" "server" {
  length = 2
  prefix = var.project_name
}

resource "random_integer" "port" {
  min = 3000
  max = 9000
}

resource "local_file" "server_info" {
  filename = "${path.module}/server-info.json"
  content = jsonencode({
    server_name = random_pet.server.id
    port        = random_integer.port.result
    project     = var.project_name
  })
}

# String output
# Output chuoi
output "server_name" {
  description = "The generated server name"
  value       = random_pet.server.id
}

# Number output
# Output so
output "server_port" {
  description = "The assigned server port"
  value       = random_integer.port.result
}

# Complex output - object
# Output phuc tap - object
output "server_config" {
  description = "Complete server configuration"
  value = {
    name    = random_pet.server.id
    port    = random_integer.port.result
    url     = "http://${random_pet.server.id}:${random_integer.port.result}"
    project = var.project_name
  }
}

# List output
# Output danh sach
output "server_endpoints" {
  description = "List of server endpoints"
  value = [
    "http://${random_pet.server.id}:${random_integer.port.result}",
    "https://${random_pet.server.id}:${random_integer.port.result + 443}"
  ]
}

# Map output
# Output map
output "server_metadata" {
  description = "Server metadata as key-value pairs"
  value = {
    "server.name"    = random_pet.server.id
    "server.port"    = tostring(random_integer.port.result)
    "server.project" = var.project_name
    "server.type"    = "demo"
  }
}

# File path output
# Output duong dan file
output "config_file" {
  description = "Path to the configuration file"
  value       = local_file.server_info.filename
}

# Sensitive output
# Output nhay cam
output "connection_string" {
  description = "Database connection string (sensitive)"
  value       = "postgres://user:pass@${random_pet.server.id}:5432/db"
  sensitive   = true
}

# Conditional output
# Output co dieu kien
output "environment_type" {
  description = "Environment type based on port"
  value       = random_integer.port.result < 5000 ? "development" : "production"
}
