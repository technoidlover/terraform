# Day 15: Introduction to Modules
# Ngay 15: Gioi thieu ve Modules

## Objectives / Muc tieu

- Understand what modules are
- Learn module structure
- Create your first module
- Use modules in configurations
- Understand module benefits

## What are Modules? / Modules la gi?

Modules are containers for multiple resources used together.
They are the main way to package and reuse resource configurations.

Modules la cac container cho nhieu resources duoc su dung cung nhau.
Chung la cach chinh de dong goi va tai su dung cac cau hinh resource.

## Module Structure / Cau truc Module

```
module/
├── main.tf           # Main resources
├── variables.tf      # Input variables
├── outputs.tf        # Output values
└── README.md         # Documentation
```

## Calling a Module / Goi Module

```hcl
module "web_server" {
  source = "./modules/web-server"
  
  instance_type = "t2.micro"
  instance_name = "web-1"
}
```

## Module Sources / Nguon Module

- Local paths: `./module`
- Terraform Registry: `terraform-aws-modules/vpc/aws`
- GitHub: `github.com/user/repo`
- HTTP URLs
- S3 buckets

## Key Takeaways / Diem Chinh

- Modules enable code reuse
- Each module is self-contained
- Modules have inputs and outputs
- Use modules for common patterns
- Document your modules

---

End of Day 15 / Ket thuc Ngay 15
