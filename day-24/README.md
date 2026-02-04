# Day 24: Testing Terraform Code
# Ngay 24: Kiem tra Ma Terraform

## Objectives / Muc tieu

- Test Terraform configurations
- Use validation tools
- Write test configurations
- Implement linting
- Automate testing

## Validation / Xac thuc

```bash
# Validate syntax
terraform validate

# Format checking
terraform fmt -check

# Security scanning with TFLint
tflint
```

## Testing Strategies / Chien luoc Kiem tra

1. Syntax validation
2. Plan review
3. Cost estimation
4. Integration testing
5. Security scanning

## Tools / Cong cu

- `terraform validate`: Syntax checking
- `terraform fmt`: Code formatting
- `terraform plan`: Review changes
- `tflint`: Linting tool
- `terraform graph`: Dependency visualization

## Best Practices / Thuc hanh Tot nhat

- Test before apply
- Review all plans
- Use automation
- Catch issues early
- Document tests

## Key Takeaways / Diem Chinh

- Always validate before apply
- Use linting tools
- Automate testing
- Review plans carefully
- Test infrastructure changes

---

End of Day 24 / Ket thuc Ngay 24
