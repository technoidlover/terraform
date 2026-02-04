# Day 28: Best Practices

Production-ready Terraform configurations following industry best practices.

## Key Topics

1. Code Organization
2. Naming Conventions
3. Security Practices
4. Documentation
5. Version Control

## Directory Structure

```
terraform/
├── README.md
├── .gitignore
├── .github/
│   └── workflows/
│       └── terraform.yml
├── modules/
│   ├── vpc/
│   ├── security-group/
│   ├── ec2/
│   └── rds/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── backend.tf
└── shared/
    ├── variables.tf
    └── outputs.tf
```

## Naming Conventions

```hcl
# Resource names: provider-resource-purpose
resource "aws_security_group" "web_alb_sg" {
  name = "web-alb-sg"
}

# Variable names: snake_case
variable "instance_type" {
  type = string
}

# Output names: snake_case
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

# Local values: descriptive snake_case
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

## Security Best Practices

### 1. Sensitive Data

```hcl
# Mark sensitive outputs
output "database_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}

# Use .gitignore for secrets
# *.tfvars
# terraform.tfstate
# *.pem
```

### 2. State File Protection

```hcl
# Enable S3 bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "terraform" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "terraform" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### 3. Least Privilege

```hcl
# Use minimal required permissions
resource "aws_iam_policy" "terraform" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.data.arn}/*"
      }
    ]
  })
}
```

## Documentation Best Practices

```hcl
# Every module should have README.md
# Every variable should have description
variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t2.micro"
}

# Every resource should be commented if complex
resource "aws_security_group" "app" {
  # Security group for application servers
  # Allows inbound on port 8080 from ALB
  # Allows outbound on all ports

  name = "app-sg"
  # ... configuration
}
```

## Testing Best Practices

```bash
# Always validate before commit
terraform fmt -recursive
terraform validate
terratest run ./tests

# Review plan carefully
terraform plan -out=tfplan
terraform show tfplan

# Use workspaces for testing
terraform workspace new test-feature
terraform plan
terraform workspace delete test-feature
```

## Version Control Best Practices

```bash
# Initialize git
git init

# Create .gitignore
# Include: *.tfvars, .terraform/, *.tfstate*

# Commit infrastructure code
git add *.tf
git commit -m "Add initial Terraform configuration"

# Use meaningful commit messages
git commit -m "Add auto-scaling policy to EC2 ASG"

# Use branches for features
git checkout -b feature/add-rds-backup
```

## Code Review Checklist

- [ ] Code follows naming conventions
- [ ] All variables have descriptions
- [ ] Sensitive data is marked
- [ ] Resources have meaningful tags
- [ ] Plan output reviewed for expected changes
- [ ] No hardcoded values (except defaults)
- [ ] Documentation is up to date
- [ ] Tests pass
- [ ] Security best practices followed

## Lab: Production-Ready Configuration

1. Reorganize code using best practices
2. Add comprehensive documentation
3. Implement security measures
4. Set up testing
5. Configure CI/CD pipeline

---

Estimated Time: 3-4 hours
