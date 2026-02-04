# Day 26: CI/CD with GitHub Actions and GitLab CI
# Configuration examples for GitOps workflows

terraform {
  required_version = ">= 1.0"
}

# This file demonstrates CI/CD integration patterns
# See .github/workflows/ for GitHub Actions examples
# See .gitlab-ci.yml for GitLab CI examples

# Example: GitHub Actions Workflow
# File: .github/workflows/terraform.yml
# Demonstrates: Plan, Validate, Format, Apply with approval

# Example: GitLab CI Configuration  
# File: .gitlab-ci.yml
# Demonstrates: Stages, artifacts, caching, environments

# Example: Environment-specific deployments
# Using matrix builds to handle multiple environments

# Example: Policy as Code (OPA/Sentinel)
# Validates Terraform plans against organization policies

# Example: Terraform Cloud integration
# For plan sharing, cost estimation, and state management

variable "ci_cd_system" {
  description = "CI/CD system being used"
  type        = string
  default     = "github-actions"

  validation {
    condition     = contains(["github-actions", "gitlab-ci", "terraform-cloud"], var.ci_cd_system)
    error_message = "Must be valid CI/CD system."
  }
}

variable "environment_name" {
  description = "Target environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment_name)
    error_message = "Must be valid environment."
  }
}

variable "auto_approve" {
  description = "Automatically approve and apply changes"
  type        = bool
  default     = false
}

variable "terraform_version" {
  description = "Terraform version constraint"
  type        = string
  default     = ">= 1.0"
}

# Local values for CI/CD configuration
locals {
  cicd_config = {
    github-actions = {
      plan_stage   = "plan"
      apply_stage  = "apply"
      destroy_stage = "destroy"
    }
    gitlab-ci = {
      plan_stage   = "validate"
      apply_stage  = "deploy"
      destroy_stage = "destroy"
    }
    terraform-cloud = {
      plan_stage   = "plan"
      apply_stage  = "apply"
      destroy_stage = "destroy"
    }
  }

  current_cicd = local.cicd_config[var.ci_cd_system]
}

# Outputs for CI/CD configuration
output "cicd_system" {
  description = "CI/CD system configuration"
  value       = var.ci_cd_system
}

output "environment" {
  description = "Target environment"
  value       = var.environment_name
}

output "terraform_version" {
  description = "Required Terraform version"
  value       = var.terraform_version
}

output "pipeline_stages" {
  description = "Pipeline stages for CI/CD"
  value       = local.current_cicd
}

output "github_actions_example" {
  description = "GitHub Actions workflow example"
  value       = <<-EOT
    name: 'Terraform'
    
    on:
      push:
        branches:
          - main
      pull_request:
    
    jobs:
      terraform:
        runs-on: ubuntu-latest
        
        steps:
          - uses: actions/checkout@v3
          
          - name: Setup Terraform
            uses: hashicorp/setup-terraform@v2
            with:
              terraform_version: 1.4.0
          
          - name: Terraform Format
            run: terraform fmt -check
          
          - name: Terraform Init
            run: terraform init
          
          - name: Terraform Validate
            run: terraform validate
          
          - name: Terraform Plan
            run: terraform plan -out=tfplan
          
          - name: Terraform Apply
            if: github.ref == 'refs/heads/main' && github.event_name == 'push'
            run: terraform apply -auto-approve tfplan
  EOT
}

output "gitlab_ci_example" {
  description = "GitLab CI configuration example"
  value       = <<-EOT
    stages:
      - validate
      - plan
      - apply
      - destroy
    
    before_script:
      - terraform init
    
    validate:
      stage: validate
      script:
        - terraform validate
        - terraform fmt -check
    
    plan:
      stage: plan
      script:
        - terraform plan -out=tfplan
      artifacts:
        paths:
          - tfplan
    
    apply:
      stage: apply
      script:
        - terraform apply -auto-approve tfplan
      when: manual
      only:
        - main
  EOT
}
