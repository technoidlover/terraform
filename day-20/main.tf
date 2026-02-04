# Conditional Expressions and Loops
# Bieu thuc Dieu kien va Vong lap

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Variables
# Bien
variable "environment" {
  type    = string
  default = "production"
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

variable "server_names" {
  type    = list(string)
  default = ["web", "api", "database"]
}

variable "server_configs" {
  type = map(object({
    port = number
    size = string
  }))
  default = {
    web = {
      port = 80
      size = "large"
    }
    api = {
      port = 8080
      size = "medium"
    }
    db = {
      port = 5432
      size = "xlarge"
    }
  }
}

# Locals with conditional expressions
# Locals voi bieu thuc dieu kien
locals {
  # Ternary conditional
  # Dieu kien ternary
  instance_type = var.environment == "production" ? "t3.large" : "t3.micro"
  
  # Conditional with boolean
  # Dieu kien voi boolean
  monitoring_config = var.enable_monitoring ? "enabled" : "disabled"
  
  # For expression - transform list
  # Bieu thuc for - bien doi list
  uppercase_names = [for name in var.server_names : upper(name)]
  
  # For expression with conditional - filter list
  # Bieu thuc for voi dieu kien - loc list
  large_servers = [for k, v in var.server_configs : k if v.size == "large" || v.size == "xlarge"]
  
  # For expression - create map from list
  # Bieu thuc for - tao map tu list
  server_urls = {
    for name in var.server_names :
    name => "http://${name}.example.com"
  }
}

# Example 1: Using count for loops
# Vi du 1: Su dung count cho vong lap
resource "local_file" "count_example" {
  # Create 3 files using count
  # Tao 3 files su dung count
  count = 3
  
  filename = "${path.module}/count-file-${count.index}.txt"
  content  = <<-EOT
    File created with count
    File duoc tao voi count
    
    Index: ${count.index}
    Chi so: ${count.index}
    
    This is file number ${count.index + 1} of ${3}
    Day la file so ${count.index + 1} trong ${3}
  EOT
}

# Example 2: Using for_each with set
# Vi du 2: Su dung for_each voi set
resource "local_file" "foreach_set" {
  # Create a file for each server name
  # Tao file cho moi ten server
  for_each = toset(var.server_names)
  
  filename = "${path.module}/server-${each.key}.txt"
  content  = <<-EOT
    Server: ${each.key}
    May chu: ${each.key}
    
    URL: ${local.server_urls[each.key]}
    
    Created with for_each
    Duoc tao voi for_each
  EOT
}

# Example 3: Using for_each with map
# Vi du 3: Su dung for_each voi map
resource "local_file" "foreach_map" {
  # Create a file for each server configuration
  # Tao file cho moi cau hinh server
  for_each = var.server_configs
  
  filename = "${path.module}/config-${each.key}.txt"
  content  = <<-EOT
    Server Configuration
    Cau hinh May chu
    ===================
    
    Name: ${each.key}
    Ten: ${each.key}
    
    Port: ${each.value.port}
    Cong: ${each.value.port}
    
    Size: ${each.value.size}
    Kich thuoc: ${each.value.size}
  EOT
}

# Example 4: Conditional resource creation
# Vi du 4: Tao resource co dieu kien
resource "local_file" "conditional" {
  # Only create if monitoring is enabled
  # Chi tao neu monitoring duoc bat
  count = var.enable_monitoring ? 1 : 0
  
  filename = "${path.module}/monitoring-config.txt"
  content  = <<-EOT
    Monitoring Enabled
    Monitoring duoc Bat
    
    Environment: ${var.environment}
    Moi truong: ${var.environment}
    
    Instance Type: ${local.instance_type}
    Loai Instance: ${local.instance_type}
  EOT
}

# Example 5: Complex for expression
# Vi du 5: Bieu thuc for phuc tap
resource "local_file" "complex_for" {
  filename = "${path.module}/complex-output.txt"
  content  = <<-EOT
    Complex For Expression Demo
    Minh hoa Bieu thuc For Phuc tap
    =================================
    
    Uppercase Names:
    Ten Viet hoa:
    ${join("\n", [for name in local.uppercase_names : "- ${name}"])}
    
    Large Servers:
    May chu Lon:
    ${join("\n", [for name in local.large_servers : "- ${name}"])}
    
    All Server URLs:
    Tat ca URL May chu:
    ${join("\n", [for k, v in local.server_urls : "- ${k}: ${v}"])}
    
    Environment Type: ${local.instance_type}
    Loai Moi truong: ${local.instance_type}
  EOT
}

# Outputs
# Outputs
output "conditional_results" {
  value = {
    instance_type     = local.instance_type
    monitoring_status = local.monitoring_config
    is_production     = var.environment == "production"
  }
}

output "loop_results" {
  value = {
    uppercase_names = local.uppercase_names
    large_servers   = local.large_servers
    server_urls     = local.server_urls
  }
}

output "files_created" {
  value = {
    count_files   = length(local_file.count_example)
    foreach_files = length(local_file.foreach_set)
    config_files  = length(local_file.foreach_map)
  }
}
