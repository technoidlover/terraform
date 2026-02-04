# Day 11: Advanced State Management
# Ngay 11: Quan ly Trang thai Nang cao

## Objectives / Muc tieu

- Master state manipulation
- Understand state file structure
- Learn state recovery techniques
- Handle state conflicts
- Implement state best practices

## State File Structure / Cau truc File State

```json
{
  "version": 4,
  "terraform_version": "1.x.x",
  "resources": [...]
}
```

## Advanced State Commands / Cac lenh State Nang cao

```bash
# Import existing resources
terraform import resource.name id

# Remove resource from state only
terraform state rm resource.name

# Move resource within state
terraform state mv source destination

# Replace provider in state
terraform state replace-provider old new
```

## State Recovery / Phuc hoi State

Steps to recover corrupted state:
1. Use backup file
2. Pull from remote
3. Reconstruct if needed

## Handling State Conflicts / Xu ly Xung dot State

- Enable state locking
- Use remote state
- Coordinate team changes
- Have backup strategy

## Key Takeaways / Diem Chinh

- State can be manipulated safely
- Always backup before changes
- Import for existing resources
- State locking prevents conflicts
- Remote state for collaboration

---

End of Day 11 / Ket thuc Ngay 11
