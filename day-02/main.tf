# This is a basic Terraform configuration demonstrating HCL syntax
# Day la cau hinh Terraform co ban minh hoa cu phap HCL

# Terraform block specifies required Terraform version and providers
# Khoi Terraform chi dinh phien ban Terraform va cac provider can thiet
terraform {
  # Require Terraform version 1.0 or higher
  # Yeu cau phien ban Terraform 1.0 hoac cao hon
  required_version = ">= 1.0"

  # Define required providers and their versions
  # Dinh nghia cac provider can thiet va phien ban cua chung
  required_providers {
    # Local provider for creating local files and directories
    # Provider local de tao file va thu muc cuc bo
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Provider block configures the specified provider
# Khoi provider cau hinh provider da chi dinh
# The local provider doesn't require additional configuration
# Provider local khong can cau hinh bo sung
provider "local" {
  # No configuration needed for local provider
  # Khong can cau hinh cho provider local
}

# Resource block defines a piece of infrastructure
# Khoi resource dinh nghia mot phan ha tang
# This creates a local file on your system
# Cai nay tao mot file cuc bo tren he thong cua ban
resource "local_file" "welcome" {
  # The filename where content will be written
  # Ten file noi dung se duoc viet vao
  filename = "${path.module}/welcome.txt"

  # The content to write to the file
  # Noi dung de viet vao file
  content = <<-EOT
    Welcome to Terraform!
    Chao mung den voi Terraform!
    
    This file was created by Terraform.
    File nay duoc tao boi Terraform.
    
    Date: ${timestamp()}
    Ngay: ${timestamp()}
  EOT

  # File permissions in Unix format
  # Quyen file theo dinh dang Unix
  file_permission = "0644"
}

# Another example resource - creates a directory
# Vi du resource khac - tao mot thu muc
resource "local_file" "info" {
  # File path using Terraform's path module
  # Duong dan file su dung module path cua Terraform
  filename = "${path.module}/terraform-info.txt"

  # Multi-line content using heredoc syntax
  # Noi dung nhieu dong su dung cu phap heredoc
  content = <<-EOT
    Terraform Basics
    ================
    
    This is Day 2 of your Terraform journey.
    Day la Ngay 2 trong hanh trinh Terraform cua ban.
    
    Key Concepts:
    Cac khai niem chinh:
    - HCL Syntax
    - Blocks and Arguments
    - Resources and Providers
    - Terraform Workflow
    
    Configuration Directory: ${path.module}
    Thu muc cau hinh: ${path.module}
  EOT

  # Set file permissions
  # Dat quyen file
  file_permission = "0644"

  # This resource depends on the welcome file
  # Resource nay phu thuoc vao file welcome
  depends_on = [local_file.welcome]
}
