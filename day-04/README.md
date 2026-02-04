# Day 4: Resources and Resource Blocks
# Ngay 4: Resources va Cac Khoi Resource

## Objectives / Muc tieu

- Understand resource blocks in depth
- Learn resource syntax and arguments
- Work with resource meta-arguments
- Understand resource addressing
- Practice creating and managing resources

- Hieu sau ve cac khoi resource
- Hoc cu phap va doi so cua resource
- Lam viec voi cac meta-argument cua resource
- Hieu ve dia chi resource
- Thuc hanh tao va quan ly resources

## Resource Block Structure / Cau truc Khoi Resource

```hcl
resource "resource_type" "resource_name" {
  argument1 = value1
  argument2 = value2
  
  nested_block {
    nested_argument = value
  }
}
```

## Meta-Arguments / Meta-Arguments

- `depends_on`: Explicit dependencies
- `count`: Create multiple instances
- `for_each`: Create instances from map/set
- `provider`: Select non-default provider
- `lifecycle`: Customize lifecycle behavior

## Resource Dependencies / Phu thuoc Resource

Terraform automatically handles implicit dependencies.
Use `depends_on` for explicit dependencies.

Terraform tu dong xu ly cac phu thuoc ngam dinh.
Su dung `depends_on` cho cac phu thuoc ro rang.

## Key Takeaways / Diem Chinh

- Resources are the core of Terraform
- Meta-arguments provide powerful control
- Dependencies can be implicit or explicit
- Resource addressing follows specific syntax
- Lifecycle rules prevent unwanted changes

---

End of Day 4 / Ket thuc Ngay 4
