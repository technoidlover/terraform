# Lab 2.1: Your First Terraform Configuration
# Bai 2.1: Cau hinh Terraform Dau tien cua Ban

## Instructions / Huong dan

Follow these steps to complete the lab:
Lam theo cac buoc nay de hoan thanh bai thuc hanh:

### Step 1: Create the configuration
### Buoc 1: Tao cau hinh

1. Copy the `main.tf` file from the parent directory
2. Review the configuration and comments
3. Understand each block and its purpose

1. Sao chep file `main.tf` tu thu muc cha
2. Xem xet cau hinh va chu thich
3. Hieu moi khoi va muc dich cua no

### Step 2: Initialize Terraform
### Buoc 2: Khoi tao Terraform

```bash
terraform init
```

This command will:
- Download the local provider
- Create .terraform directory
- Generate .terraform.lock.hcl

Lenh nay se:
- Tai provider local
- Tao thu muc .terraform
- Tao file .terraform.lock.hcl

### Step 3: Validate the configuration
### Buoc 3: Xac thuc cau hinh

```bash
terraform validate
```

Expected output: "Success! The configuration is valid."
Ket qua mong doi: "Success! The configuration is valid."

### Step 4: Format the code
### Buoc 4: Dinh dang ma

```bash
terraform fmt
```

This ensures consistent formatting.
Cai nay dam bao dinh dang nhat quan.

### Step 5: Preview the plan
### Buoc 5: Xem truoc ke hoach

```bash
terraform plan
```

Review what Terraform will create.
Xem xet nhung gi Terraform se tao.

### Step 6: Apply the configuration
### Buoc 6: Ap dung cau hinh

```bash
terraform apply
```

Type "yes" when prompted.
Nhap "yes" khi duoc nhac.

### Step 7: Verify the results
### Buoc 7: Xac minh ket qua

Check that the files were created:
Kiem tra cac file da duoc tao:

```bash
# Windows
dir welcome.txt
dir terraform-info.txt

# Linux/Mac
ls -l welcome.txt
ls -l terraform-info.txt
```

Read the file contents:
Doc noi dung file:

```bash
# Windows
type welcome.txt
type terraform-info.txt

# Linux/Mac
cat welcome.txt
cat terraform-info.txt
```

### Step 8: Explore the state
### Buoc 8: Kham pha trang thai

```bash
terraform show
```

This displays the current state.
Cai nay hien thi trang thai hien tai.

### Step 9: Clean up
### Buoc 9: Don dep

```bash
terraform destroy
```

Type "yes" to remove the created files.
Nhap "yes" de xoa cac file da tao.

## Expected Results / Ket qua Mong doi

After applying:
- Two files created: welcome.txt and terraform-info.txt
- terraform.tfstate file created
- Both files contain the expected content

Sau khi ap dung:
- Hai file duoc tao: welcome.txt va terraform-info.txt
- File terraform.tfstate duoc tao
- Ca hai file chua noi dung mong doi

## Troubleshooting / Xu ly Su co

Common issues and solutions:
Cac van de thuong gap va giai phap:

1. **Error: Failed to install provider**
   - Solution: Check internet connection, run `terraform init` again
   - Giai phap: Kiem tra ket noi internet, chay lai `terraform init`

2. **Error: Configuration is invalid**
   - Solution: Check syntax, ensure proper indentation
   - Giai phap: Kiem tra cu phap, dam bao thut le dung

3. **Files not created**
   - Solution: Check file permissions, verify apply completed
   - Giai phap: Kiem tra quyen file, xac minh apply da hoan thanh

## Learning Points / Diem Hoc tap

- `terraform init` must be run before other commands
- `terraform plan` shows changes without applying them
- `terraform apply` creates the actual infrastructure
- State file tracks what Terraform manages
- `terraform destroy` removes all managed resources

- `terraform init` phai duoc chay truoc cac lenh khac
- `terraform plan` hien thi thay doi ma khong ap dung chung
- `terraform apply` tao ha tang thuc su
- File state theo doi nhung gi Terraform quan ly
- `terraform destroy` xoa tat ca cac tai nguyen duoc quan ly

---

Lab 2.1 Complete / Hoan thanh Bai 2.1
