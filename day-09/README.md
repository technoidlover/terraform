# Day 9: Output Values
# Ngay 9: Gia tri dau ra

## Objectives / Muc tieu

- Understand output values
- Learn output syntax
- Use outputs for data sharing
- Implement output best practices
- Query outputs effectively

## Output Declaration / Khai bao Output

```hcl
output "output_name" {
  description = "Description of output"
  value       = resource.type.name.attribute
  sensitive   = false
}
```

## Output Types / Cac loai Output

Outputs can return any value type:
- Strings
- Numbers
- Lists
- Maps
- Complex objects

## Using Outputs / Su dung Outputs

```bash
# Show all outputs
terraform output

# Show specific output
terraform output output_name

# Output in JSON format
terraform output -json
```

## Output in Modules / Output trong Modules

Outputs are essential for:
- Passing data between modules
- Exposing module results
- Integration with other tools
- Debugging and verification

## Key Takeaways / Diem Chinh

- Outputs expose information
- Use descriptive names
- Add helpful descriptions
- Mark sensitive outputs
- Outputs can be referenced

---

End of Day 9 / Ket thuc Ngay 9
