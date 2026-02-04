# Day 27: Troubleshooting and Debugging Terraform
# Common issues, debugging strategies, and solutions

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Debug mode: Enable detailed logging
# Run with: TF_LOG=DEBUG terraform plan

# Example 1: State debugging
# terraform state list - List resources in state
# terraform state show <resource> - Show resource details
# terraform state rm <resource> - Remove resource from state
# terraform state pull - Get raw state file
# terraform state push <file> - Push new state

# Example 2: Plan debugging
# terraform plan -out=tfplan - Save plan to file
# terraform show tfplan - Show plan details

# Example 3: Module debugging
# Use -target flag to apply specific resources
# terraform apply -target=module.vpc

# Example 4: Provider debugging
# terraform console - Interactive console
# Can test expressions and debug issues

# Example: Common troubleshooting variable validation
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-\\d$", var.aws_region))
    error_message = "Invalid AWS region format."
  }
}

variable "debug_mode" {
  description = "Enable debug mode"
  type        = bool
  default     = false
}

variable "verbose_output" {
  description = "Enable verbose output"
  type        = bool
  default     = false
}

# Example: Locals for debugging information
locals {
  debug_info = var.debug_mode ? {
    timestamp          = timestamp()
    terraform_version  = "1.4.0"
    working_directory  = path.root
    module_path        = path.module
  } : null

  common_issues = {
    state_lock    = "Check AWS DynamoDB table for locks"
    provider_auth = "Verify AWS credentials and permissions"
    version_conflict = "Check terraform and provider versions"
    timeout        = "Increase timeout values in provider config"
  }
}

# Example: Debugging outputs
output "debug_information" {
  description = "Debug information"
  value       = var.debug_mode ? local.debug_info : "Debug mode disabled"
}

output "troubleshooting_guide" {
  description = "Common issues and solutions"
  value       = local.common_issues
}

output "useful_commands" {
  description = "Useful terraform commands for debugging"
  value = {
    "Enable detailed logging" = "TF_LOG=DEBUG terraform plan"
    "Show state" = "terraform state list"
    "Show resource details" = "terraform state show <resource>"
    "Target specific resource" = "terraform apply -target=<resource>"
    "Debug expressions" = "terraform console"
    "Validate configuration" = "terraform validate"
    "Format check" = "terraform fmt -check"
    "Graph resources" = "terraform graph"
  }
}

# Example: Resource with common troubleshooting patterns
resource "aws_instance" "debug_example" {
  count         = var.debug_mode ? 1 : 0
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.small"

  # Example: Error handling with lifecycle
  lifecycle {
    precondition {
      condition     = data.aws_ami.amazon_linux_2.id != ""
      error_message = "No valid AMI found - check region and filters"
    }

    create_before_destroy = true
    prevent_destroy       = false
  }

  tags = {
    Name = "debug-instance"
  }
}

# Get AMI for debugging
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  # Error handling
  lifecycle {
    postcondition {
      condition     = length(self.image_id) > 0
      error_message = "Failed to retrieve valid AMI"
    }
  }
}

# Troubleshooting checklist output
output "troubleshooting_checklist" {
  description = "Debugging checklist for common issues"
  value       = <<-EOT
    Before reporting issues, check:
    
    1. Terraform Version
       - terraform version
       - Ensure >= 1.0
    
    2. Provider Configuration
       - Verify provider credentials
       - Check region configuration
       - Validate provider settings
    
    3. State File
       - terraform state list
       - Check for locks: aws dynamodb scan --table-name <lock-table>
       - Remove corrupted state: terraform state rm <resource>
    
    4. Validation
       - terraform validate
       - terraform fmt -check
       - terraform plan
    
    5. Permissions
       - Verify IAM permissions
       - Check security group rules
       - Validate network access
    
    6. Debug Mode
       - TF_LOG=DEBUG terraform plan > debug.log
       - TF_LOG_PATH=terraform.log terraform plan
       - terraform console for interactive debugging
    
    7. Common Errors
       - Timeout: Increase provider timeout values
       - State Lock: Remove stale lock from DynamoDB
       - Provider Auth: Verify AWS credentials
       - Resource Exists: Use terraform import to adopt resources
  EOT
}
