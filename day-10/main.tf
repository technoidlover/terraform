# Local Values and Data Sources
# Gia tri Cuc bo va Nguon Du lieu

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

# Variables
# Bien
variable "environment" {
  type    = string
  default = "development"
}

variable "application" {
  type    = string
  default = "web-app"
}

# Local values
# Gia tri cuc bo
locals {
  # Common tags used across resources
  # Cac tag chung duoc su dung trong cac resource
  common_tags = {
    Environment = var.environment
    Application = var.application
    ManagedBy   = "Terraform"
    CreatedDate = timestamp()
  }

  # Computed naming convention
  # Quy uoc dat ten duoc tinh toan
  resource_prefix = "${var.environment}-${var.application}"

  # Complex transformation
  # Bien doi phuc tap
  tag_string = join(",", [for k, v in local.common_tags : "${k}=${v}"])

  # Conditional logic
  # Logic co dieu kien
  is_production  = var.environment == "production"
  instance_count = local.is_production ? 3 : 1
}

# Random resource for demonstration
# Resource ngau nhien de minh hoa
resource "random_pet" "server" {
  length    = 2
  prefix    = local.resource_prefix
  separator = "-"
}

# Create a file that we'll read with data source
# Tao file ma chung ta se doc voi data source
resource "local_file" "source_file" {
  filename = "${path.module}/data-source-demo.txt"
  content  = <<-EOT
    This file demonstrates data sources
    File nay minh hoa data sources
    
    Resource Prefix: ${local.resource_prefix}
    Environment: ${var.environment}
    Tags: ${local.tag_string}
  EOT
}

# Data source to read the file we created
# Data source de doc file chung ta da tao
data "local_file" "read_source" {
  filename = local_file.source_file.filename

  depends_on = [local_file.source_file]
}

# Using locals in resource configuration
# Su dung locals trong cau hinh resource
resource "local_file" "locals_demo" {
  filename = "${path.module}/${local.resource_prefix}-config.json"
  content = jsonencode({
    name       = random_pet.server.id
    prefix     = local.resource_prefix
    tags       = local.common_tags
    is_prod    = local.is_production
    count      = local.instance_count
    tag_string = local.tag_string
  })
}

# Output demonstrating locals and data sources
# Output minh hoa locals va data sources
output "resource_prefix" {
  description = "The computed resource prefix"
  value       = local.resource_prefix
}

output "is_production" {
  description = "Whether this is production environment"
  value       = local.is_production
}

output "instance_count" {
  description = "Number of instances based on environment"
  value       = local.instance_count
}

output "data_source_content" {
  description = "Content read from data source"
  value       = data.local_file.read_source.content
}

output "common_tags" {
  description = "Common tags used across resources"
  value       = local.common_tags
}
