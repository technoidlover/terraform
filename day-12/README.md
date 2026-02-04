# Day 12: Remote State and Backends
# Ngay 12: Trang thai Remote va Backends

## Objectives / Muc tieu

- Understand remote state benefits
- Configure different backends
- Implement state locking
- Migrate to remote state
- Use backend configuration

## Remote State Benefits / Loi ich Trang thai Remote

- Team collaboration
- State locking
- Secure storage
- Versioning
- Backup and recovery

## Backend Types / Cac loai Backend

- Local (default)
- S3 (AWS)
- Azure Storage
- GCS (Google)
- Terraform Cloud
- Consul
- etcd

## Backend Configuration / Cau hinh Backend

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "project/terraform.tfstate"
    region = "us-east-1"
    
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

## State Locking / Khoa State

Prevents concurrent modifications.
Most backends support automatic locking.

## Key Takeaways / Diem Chinh

- Remote state enables team collaboration
- Choose appropriate backend for your needs
- Always enable state locking
- Encrypt sensitive state data
- Plan backend migration carefully

---

End of Day 12 / Ket thuc Ngay 12
