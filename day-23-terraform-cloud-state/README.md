# Day 23: Terraform Cloud and Remote State

Manage state in Terraform Cloud, enable team collaboration, and implement state locking.

## Key Topics

1. Remote State Backends
2. Terraform Cloud Organization
3. State Locking
4. Team Management
5. Run Triggers

## Remote State with S3

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

## Terraform Cloud Backend

```hcl
terraform {
  cloud {
    organization = "my-org"

    workspaces {
      name = "production"
    }
  }
}
```

## DynamoDB Table for Locking

```hcl
resource "aws_dynamodb_table" "terraform_locks" {
  name             = "terraform-locks"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Lock"
  }
}
```

## State Management Commands

```bash
# List resources in state
terraform state list

# Show state of specific resource
terraform state show aws_instance.web

# Move resource in state
terraform state mv aws_instance.web aws_instance.app

# Remove resource from state
terraform state rm aws_instance.web

# Pull state file
terraform state pull > state.json

# Push state file
terraform state push state.json
```

## Migration to Remote State

```bash
# 1. Create remote backend
# 2. Update Terraform configuration with backend block
# 3. Run terraform init
# 4. Terraform will ask to migrate state - type yes
```

## Lab: Set Up Remote State

1. Create S3 bucket for state
2. Create DynamoDB table for locking
3. Configure terraform backend
4. Migrate existing state
5. Verify state locking works

---

Estimated Time: 2-3 hours
