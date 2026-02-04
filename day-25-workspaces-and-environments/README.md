# Day 25: Workspaces and Environments

Manage multiple environments using workspaces and environment-specific configurations.

## Key Topics

1. Workspaces
2. Environment Separation
3. Backend Configuration Per Environment
4. Variable Files Per Environment
5. Best Practices

## Workspaces

```bash
# List workspaces
terraform workspace list

# Create workspace
terraform workspace new production

# Select workspace
terraform workspace select production

# Delete workspace
terraform workspace delete staging
```

## Using Workspaces in Configuration

```hcl
locals {
  environment = terraform.workspace
}

resource "aws_instance" "app" {
  instance_type = local.environment == "production" ? "t2.large" : "t2.micro"

  tags = {
    Environment = local.environment
  }
}

# Different state files per workspace
output "state_path" {
  value = "env:/${terraform.workspace}/terraform.tfstate"
}
```

## Environment-Specific Variables

Directory structure:

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── prod.tfvars
└── dev.tfvars
```

Using environment files:

```bash
# Development
terraform plan -var-file=dev.tfvars

# Production
terraform plan -var-file=prod.tfvars
```

## Environment Configuration

```hcl
variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "tags" {
  type = map(string)
}

resource "aws_instance" "app" {
  count         = var.instance_count
  instance_type = var.instance_type

  tags = var.tags
}
```

Environment files:

```hcl
# dev.tfvars
instance_type  = "t2.micro"
instance_count = 1
tags = {
  Environment = "development"
}

# prod.tfvars
instance_type  = "t2.large"
instance_count = 3
tags = {
  Environment = "production"
}
```

## Backend Configuration Per Environment

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

For production, change key to `prod/terraform.tfstate`.

## Lab: Multi-Environment Setup

1. Create development and production workspaces
2. Create environment-specific variable files
3. Deploy same configuration to both environments
4. Verify different resource sizes in each
5. Destroy test resources

---

Estimated Time: 2-3 hours
