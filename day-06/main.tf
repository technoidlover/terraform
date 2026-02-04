# Complete Workflow Demonstration
# Minh hoa Quy trinh Hoan chinh

terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Variable for demonstration
# Bien de minh hoa
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}

# Resource demonstrating full workflow
# Resource minh hoa quy trinh day du
resource "local_file" "workflow_demo" {
  filename = "${path.module}/workflow-${var.environment}.txt"
  content  = <<-EOT
    Terraform Workflow Demonstration
    Minh hoa Quy trinh Terraform
    ================================
    
    Environment: ${var.environment}
    Moi truong: ${var.environment}
    
    Workflow Steps:
    Cac buoc Quy trinh:
    1. terraform init
    2. terraform fmt
    3. terraform validate
    4. terraform plan
    5. terraform apply
    6. terraform output
    7. terraform destroy
    
    Created at: ${timestamp()}
    Tao luc: ${timestamp()}
  EOT
}

# Output values
# Gia tri dau ra
output "file_path" {
  description = "Path to created file"
  value       = local_file.workflow_demo.filename
}

output "environment" {
  description = "Current environment"
  value       = var.environment
}
