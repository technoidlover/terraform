# Day 10: Local Values and Data Sources
# Ngay 10: Gia tri Cuc bo va Nguon Du lieu

## Objectives / Muc tieu

- Understand local values
- Learn about data sources
- Use locals for DRY principle
- Query existing infrastructure
- Combine locals and data sources

## Local Values / Gia tri Cuc bo

Locals reduce repetition and improve readability.

```hcl
locals {
  common_tags = {
    Project   = "MyProject"
    ManagedBy = "Terraform"
  }
  
  instance_name = "${var.environment}-${var.application}"
}
```

## Data Sources / Nguon Du lieu

Data sources query existing infrastructure.

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
```

## When to Use Each / Khi nao Su dung Moi cai

Locals:
- Computed values
- Repeated expressions
- Complex transformations

Data Sources:
- Query existing resources
- External data
- Provider-managed resources

## Key Takeaways / Diem Chinh

- Locals simplify complex expressions
- Data sources read existing infrastructure
- Both improve code maintainability
- Locals cannot be changed after definition
- Data sources run during plan phase

---

End of Day 10 / Ket thuc Ngay 10
