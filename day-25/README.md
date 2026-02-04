# Day 25: CI/CD with Terraform
# Ngay 25: CI/CD voi Terraform

## Objectives / Muc tieu

- Integrate Terraform in CI/CD
- Automate deployments
- Implement approval workflows
- Use CI/CD platforms
- Practice infrastructure automation

## CI/CD Pipeline Stages / Cac Giai doan Pipeline CI/CD

1. **Validate**: Syntax checking
2. **Plan**: Generate execution plan
3. **Review**: Approval process
4. **Apply**: Deploy changes
5. **Destroy**: Cleanup (optional)

## Common Platforms / Cac Nen tang Thuong gap

- GitHub Actions
- GitLab CI/CD
- Jenkins
- CircleCI
- AWS CodePipeline
- Azure Pipelines

## Example GitHub Actions / Vi du GitHub Actions

```yaml
name: Terraform

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  terraform:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v1
      
      - name: Validate
        run: terraform validate
      
      - name: Plan
        run: terraform plan -out=tfplan
      
      - name: Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply tfplan
```

## Key Practices / Cac Thuc hanh Chinh

- Automatic validation
- Approval gates
- State management
- Secret handling
- Rollback procedures

## Key Takeaways / Diem Chinh

- Automate validation and testing
- Implement approval workflows
- Manage secrets securely
- Version control all code
- Monitor changes
- Plan rollback strategies

---

End of Day 25 / Ket thuc Ngay 25
