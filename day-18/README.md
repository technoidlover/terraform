# Day 18: Workspaces
# Ngay 18: Khong gian Lam viec

## Objectives / Muc tieu

- Understand Terraform workspaces
- Create and manage workspaces
- Use workspaces for environments
- Understand workspace limitations
- Implement workspace best practices

## What are Workspaces? / Workspaces la gi?

Workspaces allow you to manage multiple states for the same configuration.

Workspaces cho phep ban quan ly nhieu states cho cung mot cau hinh.

## Workspace Commands / Cac lenh Workspace

```bash
# List workspaces
terraform workspace list

# Create new workspace
terraform workspace new dev

# Select workspace
terraform workspace select dev

# Show current workspace
terraform workspace show

# Delete workspace
terraform workspace delete dev
```

## Using Workspaces / Su dung Workspaces

```hcl
resource "local_file" "example" {
  filename = "${terraform.workspace}-config.txt"
  content  = "Environment: ${terraform.workspace}"
}
```

## When to Use Workspaces / Khi nao Su dung Workspaces

Good for:
- Multiple environments
- Testing configurations
- Temporary deployments

Not recommended for:
- Completely different infrastructures
- Different backends
- Production isolation

## Key Takeaways / Diem Chinh

- Workspaces manage multiple states
- Default workspace always exists
- Use for similar environments
- Consider alternatives for production
- State isolation is important

---

End of Day 18 / Ket thuc Ngay 18
