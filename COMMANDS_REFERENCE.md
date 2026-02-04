# Common Terraform Commands Reference
# Tai lieu Tham chieu Cac lenh Terraform Thuong gap

This quick reference guide covers the most commonly used
Terraform commands.

Tai lieu tham chieu nhanh nay bao gom cac lenh Terraform
duoc su dung pho bien nhat.

## Initialization Commands / Cac lenh Khoi tao

### terraform init
Initialize a working directory containing Terraform files.
Khoi tao thu muc lam viec chua cac file Terraform.

```bash
terraform init
```

Options:
- `-upgrade`: Upgrade provider versions
- `-backend=false`: Skip backend configuration
- `-reconfigure`: Reconfigure the backend

### terraform get
Download and install Terraform modules.
Tai xuong va cai dat cac module Terraform.

```bash
terraform get
terraform get -update
```

## Validation Commands / Cac lenh Xac thuc

### terraform validate
Validate the syntax of configuration files.
Xac thuc cu phap cua cac file cau hinh.

```bash
terraform validate
```

### terraform fmt
Format Terraform code according to style conventions.
Dinh dang ma Terraform theo quy uoc phong cach.

```bash
terraform fmt                 # Format current directory
terraform fmt directory/      # Format specific directory
terraform fmt -check         # Check without formatting
terraform fmt -recursive      # Format recursively
```

## Inspection Commands / Cac lenh Kiem tra

### terraform show
Display current state or saved plan.
Hien thi trang thai hien tai hoac ke hoach da luu.

```bash
terraform show
terraform show tfplan          # Show saved plan
```

### terraform graph
Generate visual dependency graph.
Tao do thi phu thuoc hinh anh.

```bash
terraform graph | dot -Tpng > graph.png
```

### terraform output
Display output values.
Hien thi cac gia tri dau ra.

```bash
terraform output                      # Show all outputs
terraform output output_name          # Show specific output
terraform output -json               # JSON format
terraform output -raw output_name    # Raw value only
```

### terraform console
Interactive console for evaluating expressions.
Giao dien tuong tac de danh gia bieu thuc.

```bash
terraform console
```

## Planning and Applying / Ke hoach va Ap dung

### terraform plan
Show execution plan (changes that will be made).
Hien thi ke hoach thuc thi (cac thay doi se duoc thuc hien).

```bash
terraform plan
terraform plan -out=tfplan              # Save plan to file
terraform plan -destroy                 # Plan for destroy
terraform plan -var="key=value"        # Override variables
terraform plan -var-file="file.tfvars" # Load variables
```

### terraform apply
Apply changes to create/update/destroy resources.
Ap dung thay doi de tao/cap nhat/huy tai nguyen.

```bash
terraform apply
terraform apply tfplan                  # Apply saved plan
terraform apply -auto-approve          # Skip confirmation
terraform apply -var="key=value"       # Override variables
terraform apply -target=resource.name  # Apply specific resource
```

### terraform destroy
Destroy all managed resources.
Huy tat ca tai nguyen duoc quan ly.

```bash
terraform destroy
terraform destroy -auto-approve        # Skip confirmation
terraform destroy -target=resource     # Destroy specific resource
```

## State Management / Quan ly Trang thai

### terraform state list
List all resources in state.
Liet ke tat ca tai nguyen trong trang thai.

```bash
terraform state list
terraform state list resource.type.*   # List by pattern
```

### terraform state show
Show detailed state of a resource.
Hien thi trang thai chi tiet cua tai nguyen.

```bash
terraform state show resource.name
terraform state show 'resource.name[0]'  # For count resources
terraform state show 'resource.name["key"]'  # For for_each
```

### terraform state mv
Move/rename a resource in state.
Di chuyen/doi ten tai nguyen trong trang thai.

```bash
terraform state mv source.name destination.name
```

### terraform state rm
Remove resource from state (doesn't delete actual resource).
Xoa tai nguyen khoi trang thai (khong xoa tai nguyen thuc).

```bash
terraform state rm resource.name
```

### terraform state pull
Get current state and output as JSON.
Lay trang thai hien tai va xuat ra JSON.

```bash
terraform state pull > backup.json
```

### terraform state push
Update remote state from local backup.
Cap nhat trang thai tu xa tu sao luu cuc bo.

```bash
terraform state push backup.json
```

## Debugging Commands / Cac lenh Giai quyet su co

### terraform plan -json
Output plan in JSON for parsing.
Xuat ke hoach duoi dang JSON de phan tich.

```bash
terraform plan -json > plan.json
```

### terraform refresh
Sync state file with real resources.
Dong bo file trang thai voi tai nguyen thuc.

```bash
terraform refresh
```

### Environment Variables / Bien Moi truong

Set for debugging:
- `TF_LOG=DEBUG`: Enable debug logging
- `TF_LOG_PATH=/path/to/file`: Log to file

```bash
set TF_LOG=DEBUG
terraform apply
```

## Workspace Commands / Cac lenh Workspace

### terraform workspace list
List available workspaces.
Liet ke cac workspace co san.

```bash
terraform workspace list
```

### terraform workspace new
Create new workspace.
Tao workspace moi.

```bash
terraform workspace new dev
```

### terraform workspace select
Select workspace to use.
Chon workspace de su dung.

```bash
terraform workspace select dev
```

### terraform workspace delete
Delete a workspace.
Xoa workspace.

```bash
terraform workspace delete staging
```

### terraform workspace show
Display current workspace.
Hien thi workspace hien tai.

```bash
terraform workspace show
```

## Import Commands / Cac lenh Nhap khau

### terraform import
Import existing resource into state.
Nhap tai nguyen co san vao trang thai.

```bash
terraform import resource.name id
terraform import aws_instance.example i-1234567890abcdef0
```

## Useful Combinations / Cac to hop Huu ich

### Full Workflow
```bash
terraform init
terraform fmt
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

### Safe Destroy
```bash
terraform plan -destroy -out=tfplan
terraform apply tfplan
```

### Debugging Issues
```bash
terraform validate
terraform plan
terraform show current.json
terraform state list
```

## Quick Reference / Tham chieu Nhanh

| Command | Purpose | Lenh | Muc dich |
|---------|---------|------|---------|
| init | Initialize | Khoi tao | |
| fmt | Format code | Dinh dang ma | |
| validate | Check syntax | Kiem tra cu phap | |
| plan | Show changes | Hien thi thay doi | |
| apply | Make changes | Thuc hien thay doi | |
| destroy | Remove all | Xoa tat ca | |
| state | Manage state | Quan ly trang thai | |
| output | Show outputs | Hien thi dau ra | |
| show | Display state | Hien thi trang thai | |
| workspace | Manage workspaces | Quan ly workspaces | |

## Safety Tips / Meo An toan

1. Always run `plan` before `apply`
   Luon chay `plan` truoc `apply`

2. Review plan output carefully
   Xem xet dau ra ke hoach can than

3. Use `-out` flag to save plans
   Su dung co `-out` de luu ke hoach

4. Use `-target` carefully
   Su dung `-target` can than

5. Backup state before major changes
   Sao luu trang thai truoc thay doi lon

6. Use `-auto-approve` only in CI/CD
   Chi su dung `-auto-approve` trong CI/CD

7. Test in non-prod first
   Kiem tra trong non-prod truoc

8. Keep state encrypted and backed up
   Giu trang thai ma hoa va sao luu

---

For complete documentation, visit: https://www.terraform.io/docs/commands
De xem tai lieu day du, tham khao: https://www.terraform.io/docs/commands
