# Day 17: Module Registry and Public Modules
# Ngay 17: Registry Module va Module Cong khai

## Objectives / Muc tieu

- Understand Terraform Registry
- Use public modules
- Publish your own modules
- Evaluate module quality
- Contribute to community

## Terraform Registry / Registry Terraform

Official registry: https://registry.terraform.io

Features:
- Verified modules
- Version history
- Documentation
- Usage examples
- Download statistics

## Using Registry Modules / Su dung Module Registry

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"
}
```

## Publishing Modules / Xuat ban Modules

Requirements:
- GitHub repository
- Semantic versioning
- Standard structure
- README documentation

## Key Takeaways / Diem Chinh

- Registry provides verified modules
- Use version constraints
- Review before using
- Contribute back to community
- Follow publishing guidelines

---

End of Day 17 / Ket thuc Ngay 17
