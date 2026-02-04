# Day 5: Terraform State Basics
# Ngay 5: Co ban ve Trang thai Terraform

## Objectives / Muc tieu

- Understand what Terraform state is
- Learn how state is stored
- Work with state commands
- Understand state locking
- Learn state best practices

- Hieu trang thai Terraform la gi
- Hoc cach trang thai duoc luu tru
- Lam viec voi cac lenh state
- Hieu ve khoa state
- Hoc cac thuc hanh tot nhat ve state

## What is Terraform State? / Trang thai Terraform la gi?

State is a JSON file that maps your configuration to real-world resources.
It tracks metadata and improves performance for large infrastructures.

State la file JSON anh xa cau hinh cua ban voi cac tai nguyen thuc te.
No theo doi metadata va cai thien hieu suat cho ha tang lon.

## State File / File State

Default state file: `terraform.tfstate`
Backup file: `terraform.tfstate.backup`

File state mac dinh: `terraform.tfstate`
File sao luu: `terraform.tfstate.backup`

## State Commands / Cac lenh State

```bash
# List resources in state
# Liet ke cac resource trong state
terraform state list

# Show details of a resource
# Hien thi chi tiet cua mot resource
terraform state show <resource_address>

# Move a resource in state
# Di chuyen mot resource trong state
terraform state mv <source> <destination>

# Remove a resource from state
# Xoa mot resource khoi state
terraform state rm <resource_address>

# Pull current state
# Keo trang thai hien tai
terraform state pull

# Push state to remote
# Day trang thai len remote
terraform state push
```

## State Locking / Khoa State

State locking prevents concurrent modifications.
Most backends support automatic state locking.

Khoa state ngan chan cac thay doi dong thoi.
Hau het cac backend ho tro khoa state tu dong.

## Best Practices / Thuc hanh Tot nhat

1. Never edit state files manually
2. Use remote state for team collaboration
3. Enable state locking
4. Keep state files secure
5. Use state backups

1. Khong bao gio chinh sua file state thu cong
2. Su dung trang thai remote cho cong tac nhom
3. Bat khoa state
4. Giu file state an toan
5. Su dung sao luu state

## Key Takeaways / Diem Chinh

- State tracks real infrastructure
- State file should never be manually edited
- State commands help manage state safely
- State locking prevents conflicts
- Remote state is essential for teams

---

End of Day 5 / Ket thuc Ngay 5
