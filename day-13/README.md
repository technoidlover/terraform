# Day 13: Resource Dependencies
# Ngay 13: Phu thuoc Tai nguyen

## Objectives / Muc tieu

- Understand implicit dependencies
- Use explicit dependencies
- Create dependency graphs
- Manage complex dependencies
- Optimize resource ordering

## Implicit Dependencies / Phu thuoc Ngam dinh

Terraform automatically detects dependencies when you reference other resources.

```hcl
resource "aws_instance" "app" {
  subnet_id = aws_subnet.main.id  # Implicit dependency
}
```

## Explicit Dependencies / Phu thuoc Ro rang

Use `depends_on` when dependencies aren't obvious.

```hcl
resource "aws_instance" "app" {
  # ...
  
  depends_on = [aws_iam_role_policy.example]
}
```

## Dependency Graph / Do thi Phu thuoc

```bash
# Generate visual dependency graph
terraform graph | dot -Tpng > graph.png
```

## Key Takeaways / Diem Chinh

- Implicit dependencies are automatic
- Use depends_on for hidden dependencies
- Dependency graph helps visualization
- Circular dependencies cause errors
- Plan order follows dependencies

---

End of Day 13 / Ket thuc Ngay 13
