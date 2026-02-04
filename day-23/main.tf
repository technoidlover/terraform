# Security Best Practices Examples
# Vi du Thuc hanh Bao mat Tot nhat

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# EXAMPLE 1: Sensitive Variables
# VI DU 1: Bien Nhay cam

variable "database_password" {
  description = "Database password - marked as sensitive"
  type        = string
  sensitive   = true
  default     = "default-placeholder"
}

variable "api_token" {
  description = "API token - marked as sensitive"
  type        = string
  sensitive   = true
  default     = "placeholder-token"
}

# EXAMPLE 2: Using locals to hide sensitive info
# VI DU 2: Su dung locals de an nhay cam

locals {
  # Never store actual credentials here
  # Khong bao gio luu thong tin nhay cam o day
  # Use environment variables or secret management instead
  # Su dung bien moi truong hoac quan ly bi mat thay the
  
  database_config = {
    host     = "db.example.com"
    port     = 5432
    username = "admin"
    # Password should come from variable
    password = var.database_password
  }
}

# EXAMPLE 3: Resource with sensitive data
# VI DU 3: Resource voi du lieu nhay cam

resource "local_file" "config" {
  filename = "${path.module}/config.txt"
  content  = <<-EOT
    Configuration File
    File cau hinh
    ====================
    
    Database Configuration:
    Cau hinh Co so du lieu:
    
    Host: ${local.database_config.host}
    Port: ${local.database_config.port}
    Username: ${local.database_config.username}
    
    Note: Passwords should be managed separately
    Luu y: Passwords nen duoc quan ly rieng biet
  EOT
  
  # Prevent accidental commits
  # Ngan chan commit nham
  file_permission = "0600"
}

# EXAMPLE 4: Output with sensitive flag
# VI DU 4: Output voi co sen nhay cam

output "database_config" {
  description = "Database configuration (with sensitive password)"
  value = {
    host     = local.database_config.host
    port     = local.database_config.port
    username = local.database_config.username
    password = var.database_password
  }
  sensitive = true
}

# EXAMPLE 5: Environment-specific configurations
# VI DU 5: Cac cau hinh co the theo moi truong

variable "environment" {
  type    = string
  default = "development"
}

locals {
  # Different security levels per environment
  # Cac muc bao mat khac nhau tuy theo moi truong
  environment_config = {
    development = {
      require_mfa     = false
      encryption      = "optional"
      access_logging  = false
      public_access   = true
    }
    staging = {
      require_mfa     = true
      encryption      = "required"
      access_logging  = true
      public_access   = false
    }
    production = {
      require_mfa     = true
      encryption      = "required"
      access_logging  = true
      public_access   = false
    }
  }
  
  current_environment_config = local.environment_config[var.environment]
}

output "environment_security_config" {
  description = "Security configuration for current environment"
  value       = local.current_environment_config
}

# Security reminder
# Nhan dam Bao mat
output "security_reminders" {
  value = <<-EOT
    SECURITY BEST PRACTICES / THUC HANH BAO MAT TOT NHAT:
    
    1. Never commit secrets to version control
       Khong bao gio commit bi mat toi version control
    
    2. Use environment variables for sensitive data
       Su dung bien moi truong cho du lieu nhay cam
    
    3. Rotate credentials regularly
       Quay phim thong tin xac thuc thuong xuyen
    
    4. Use remote state with encryption
       Su dung remote state voi ma hoa
    
    5. Enable state locking
       Bat khoa state
    
    6. Use IAM roles instead of static credentials
       Su dung IAM roles thay the thong tin xac thuc tinh
    
    7. Audit all changes
       Kiem tra tat ca thay doi
    
    8. Use separate environments
       Su dung cac moi truong rieng biet
  EOT
}
