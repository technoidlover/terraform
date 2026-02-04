# Day 24: Testing and Validation

Test Terraform configurations and validate infrastructure code.

## Key Topics

1. Terraform Validate
2. Terraform Format
3. Testing Tools (Terratest, tftest)
4. Security Scanning
5. Cost Estimation

## Validation Commands

```bash
# Validate syntax
terraform validate

# Format check
terraform fmt -check

# Recursive format check
terraform fmt -check -recursive

# Format and fix
terraform fmt -recursive

# Deep validation
terraform plan -out=plan.tfplan
terraform show plan.tfplan
```

## Terratest

Basic Go test example:

```go
package test

import (
  "testing"
  "github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAwsExample(t *testing.T) {
  terraformOptions := &terraform.Options{
    TerraformDir: "../",
  }

  defer terraform.Destroy(t, terraformOptions)
  terraform.InitAndApply(t, terraformOptions)

  output := terraform.Output(t, terraformOptions, "instance_id")
  if output == "" {
    t.Fatal("instance_id output is empty")
  }
}
```

## Tflint for Code Quality

```bash
# Install tflint
# https://github.com/terraform-linters/tflint

# Run linting
tflint

# Run with specific rules
tflint --enable-rule=terraform_required_version
```

## Checkov for Security

```bash
# Install checkov
pip install checkov

# Scan Terraform files
checkov --directory . --framework terraform

# Scan specific check
checkov --check CKV_AWS_1 --directory .
```

## Cost Estimation

```bash
# Using terraform plan
terraform plan -out=plan.tfplan

# Using Infracost
infracost breakdown --path .
infracost diff --path . --format table
```

## Lab: Test Configuration

1. Create test configuration
2. Run terraform validate
3. Format with terraform fmt
4. Scan with tflint
5. Check security with checkov

---

Estimated Time: 2-3 hours
