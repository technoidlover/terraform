# Advanced State Management Examples
# Vi du Quan ly Trang thai Nang cao

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Create multiple resources to demonstrate state operations
# Tao nhieu resource de minh hoa cac thao tac state

# Resource group 1
# Nhom resource 1
resource "local_file" "file_a" {
  filename = "${path.module}/state-demo-a.txt"
  content  = "This is file A for state management demo"
}

resource "local_file" "file_b" {
  filename = "${path.module}/state-demo-b.txt"
  content  = "This is file B for state management demo"
}

# Resource group 2
# Nhom resource 2
resource "local_file" "config_dev" {
  filename = "${path.module}/dev-config.txt"
  content  = "Development configuration"
}

resource "local_file" "config_prod" {
  filename = "${path.module}/prod-config.txt"
  content  = "Production configuration"
}

# Output for state verification
# Output de xac minh state
output "all_files" {
  value = {
    file_a      = local_file.file_a.filename
    file_b      = local_file.file_b.filename
    config_dev  = local_file.config_dev.filename
    config_prod = local_file.config_prod.filename
  }
}
