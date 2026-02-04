# Day 23: Security and Secrets Management
# Ngay 23: Bao mat va Quan ly Bi mat

## Objectives / Muc tieu

- Implement security best practices
- Manage sensitive data
- Use encryption
- Control access
- Prevent credential leaks

## Sensitive Variables / Bien Nhay cam

Mark variables as sensitive:
```hcl
variable "database_password" {
  type      = string
  sensitive = true
}
```

Benefits:
- Hidden from logs
- Not displayed in output
- Still stored in state

## Secret Management / Quan ly Bi mat

Methods:
1. Environment variables: `TF_VAR_name`
2. Separate tfvars files: `terraform.tfvars.secret`
3. Vault for secret storage
4. Cloud KMS services
5. Parameter stores

## Preventing Credential Leaks / Ngan chan Ro ri Thong tin

- Never hardcode credentials
- Use variable defaults carefully
- Gitignore sensitive files
- Use temporary credentials
- Rotate keys regularly
- Monitor logs

## Access Control / Kiem soat Truy cap

- Use IAM roles
- Limit provider permissions
- State access restrictions
- Encrypt state
- Require MFA

## Best Practices / Thuc hanh Tot nhat

- Separate environments
- Use managed services
- Regular security audits
- Monitor API calls
- Log all changes

## Key Takeaways / Diem Chinh

- Mark sensitive data
- Never hardcode secrets
- Use vault or KMS
- Control access strictly
- Encrypt everything
- Audit regularly
- Follow principle of least privilege

---

End of Day 23 / Ket thuc Ngay 23
