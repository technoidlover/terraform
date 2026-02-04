# Day 6: State Management

Terraform maintains state to track deployed infrastructure. Understand how to manage, backup, and protect state files.

## Key Topics

1. State File Structure
2. Local vs Remote State
3. State Backends
4. State Locking
5. State Migration

## State File

The terraform.tfstate file contains JSON representation of deployed resources.

```json
{
  "version": 4,
  "terraform_version": "1.5.0",
  "serial": 3,
  "lineage": "abc123",
  "outputs": {},
  "resources": [
    {
      "type": "aws_instance",
      "name": "web",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "id": "i-0123456789abcdef0",
            "instance_type": "t2.micro"
          }
        }
      ]
    }
  ]
}
```

## Remote State Backends

S3 backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

## Lab: Remote State with S3

```hcl
# Create S3 bucket for state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name = "Terraform State"
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Create DynamoDB table for locking
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Lock"
  }
}
```

State commands:

```bash
terraform state list
terraform state show aws_instance.web
terraform state mv aws_instance.web aws_instance.app
terraform state rm aws_instance.web
```

---

Estimated Time: 2 hours
