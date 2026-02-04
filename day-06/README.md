# Day 6: Terraform Commands and Workflow
# Ngay 6: Cac lenh Terraform va Quy trinh Lam viec

## Objectives / Muc tieu

- Master essential Terraform commands
- Understand the complete workflow
- Learn debugging techniques
- Practice command options
- Understand when to use each command

## Essential Commands / Cac lenh Thiet yeu

### Initialization / Khoi tao
```bash
terraform init          # Initialize directory
terraform init -upgrade # Upgrade providers
```

### Planning / Ke hoach
```bash
terraform plan                    # Show execution plan
terraform plan -out=tfplan       # Save plan to file
terraform plan -destroy          # Plan destruction
```

### Applying / Ap dung
```bash
terraform apply                  # Apply changes
terraform apply tfplan           # Apply saved plan
terraform apply -auto-approve    # Skip confirmation
```

### Destruction / Huy
```bash
terraform destroy                # Destroy all resources
terraform destroy -auto-approve  # Skip confirmation
```

### Other Commands / Cac lenh Khac
```bash
terraform fmt       # Format code
terraform validate  # Validate configuration
terraform show      # Show current state
terraform output    # Show output values
terraform refresh   # Update state
terraform graph     # Generate dependency graph
```

## Workflow Best Practices / Thuc hanh Tot nhat Quy trinh

1. Always run `plan` before `apply`
2. Use `-out` flag to save plans
3. Format code regularly with `fmt`
4. Validate before committing
5. Use workspaces for environments

## Key Takeaways / Diem Chinh

- Master the core workflow: init, plan, apply
- Always review plans before applying
- Use automation flags carefully
- Format and validate regularly
- Understand each command's purpose

---

End of Day 6 / Ket thuc Ngay 6
