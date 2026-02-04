# Workspace Examples
# Vi du Workspace

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Variable that changes based on workspace
# Bien thay doi dua tren workspace
locals {
  # Different configurations for each workspace
  # Cac cau hinh khac nhau cho moi workspace
  workspace_configs = {
    default = {
      instance_count = 1
      instance_size  = "small"
    }
    dev = {
      instance_count = 1
      instance_size  = "small"
    }
    staging = {
      instance_count = 2
      instance_size  = "medium"
    }
    prod = {
      instance_count = 3
      instance_size  = "large"
    }
  }
  
  # Get configuration for current workspace
  # Lay cau hinh cho workspace hien tai
  current_config = local.workspace_configs[terraform.workspace]
}

# Resource that uses workspace information
# Resource su dung thong tin workspace
resource "local_file" "workspace_config" {
  filename = "${path.module}/${terraform.workspace}-configuration.txt"
  content  = <<-EOT
    Workspace Configuration
    Cau hinh Workspace
    ====================
    
    Current Workspace: ${terraform.workspace}
    Workspace hien tai: ${terraform.workspace}
    
    Instance Count: ${local.current_config.instance_count}
    So Instance: ${local.current_config.instance_count}
    
    Instance Size: ${local.current_config.instance_size}
    Kich thuoc Instance: ${local.current_config.instance_size}
    
    Configuration determined by workspace name
    Cau hinh duoc xac dinh boi ten workspace
  EOT
}

# Output workspace information
# Output thong tin workspace
output "current_workspace" {
  description = "The currently selected workspace"
  value       = terraform.workspace
}

output "instance_config" {
  description = "Configuration for current workspace"
  value       = local.current_config
}
