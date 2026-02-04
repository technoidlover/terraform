# Terraform 30-Day Course - Quick Start Guide
# Khoa hoc Terraform 30 ngay - Huong dan Bat dau Nhanh chong

## Getting Started / Bat dau

### 1. Prerequisites / Tien quyet

- Terraform installed (version 1.0+)
- AWS account (or another cloud provider)
- Text editor (VS Code recommended)
- Git for version control
- Basic command line knowledge

### 2. Directory Structure / Cau truc Thu muc

```
e:\terraform\
├── README.md                    # Main overview / Tong quan chinh
├── QUICK_START.md              # This file / File nay
├── day-01/                      # Day 1 materials
│   ├── README.md
│   └── example.tf
├── day-02/                      # Day 2 materials
│   ├── README.md
│   ├── main.tf
│   └── lab-2.1-first-config/
├── ... (days 3-30)
└── LEARNING_PATH.md            # Learning path / Duong dan hoc tap
```

### 3. How to Use Each Day / Cach su dung Moi ngay

1. **Read the README.md**
   - Contains theory and concepts
   - Chu chua ly thuyet va khai niem

2. **Study the Code**
   - Review example.tf or main.tf
   - Code duoc comment day du
   - All comments in bilingual format
   - Cac chu thich song ngu

3. **Complete Lab Exercises**
   - Follow step-by-step instructions
   - Lam theo huong dan chi tiet
   - Practice commands
   - Thuc hanh cac lenh

4. **Review Outputs**
   - Understand results
   - Compare with expectations
   - Xem xet ket qua

### 4. Learning Tips / Meo Hoc tap

- Don't just read, practice hands-on
- Khong chi doc, thuc hanh tay
- Type commands yourself
- Tu nhap cac lenh
- Experiment with examples
- Thuc nghiem voi cac vi du
- Take notes
- Ghi chu quan trong
- Ask questions
- Dat cau hoi

### 5. Daily Schedule / Lich trinh Hang ngay

- **1-2 hours per day** recommended
- Read README: 20-30 minutes
- Study code: 20-30 minutes
- Practice labs: 20-40 minutes
- Review: 10 minutes

### 6. Week-by-Week Progression / Tien trinh Tung tuan

**Week 1: Basics** (Days 1-7)
- Foundation knowledge
- First configurations
- Understanding workflow

**Week 2: Core Concepts** (Days 8-14)
- Variables and outputs
- State management
- Advanced features

**Week 3: Advanced** (Days 15-21)
- Modules and reusability
- Complex configurations
- Function and loops

**Week 4: Production** (Days 22-30)
- Best practices
- Real-world projects
- Team collaboration

### 7. Common Commands / Cac lenh Thuong gap

```bash
# Before working with a day's code
# Truoc khi lam viec voi ma cua ngay do

cd e:\terraform\day-XX

# Initialize Terraform
terraform init

# Format code
terraform fmt

# Validate configuration
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply

# View results
terraform output

# Cleanup
terraform destroy
```

### 8. Troubleshooting / Khac phuc su co

**Problem: terraform init fails**
- Check internet connection
- Ensure Terraform is installed
- Verify file permissions

**Problem: validation errors**
- Check HCL syntax
- Review comments for hints
- Use terraform fmt

**Problem: apply fails**
- Review error message
- Check plan output
- Verify resources don't exist

### 9. Getting Help / Nhan tro giup

Each day's README includes:
- Detailed explanations in both languages
- Example code with comments
- Common issues and solutions
- Additional resources

### 10. Next Steps After Course / Sau khoa hoc

1. Review all 30 days
2. Build your own project
3. Practice with real cloud provider
4. Join community
5. Study advanced topics
6. Take certification exam

## File Organization / To chuc File

Each day folder contains:
- **README.md** - Theory and objectives
- **main.tf or example.tf** - Working code examples
- **terraform.tfvars** - Sample variable values
- **lab-X.X-name/** - Lab exercises with instructions

## Bilingual Content / Noi dung Song ngu

All materials are in both:
- English / Tieng Anh
- Vietnamese / Tieng Viet

No emojis or icons are used / Khong su dung emoji hoac icon

Comments in code explain:
- What the code does / Code lam gi
- Why it's written that way / Tai sao viet nhu vay
- How to use it / Cach su dung

## Tips for Success / Meo thanh cong

1. Follow the days in order
   Lam theo thu tu cac ngay

2. Don't skip content
   Khong bo qua noi dung

3. Practice all examples
   Thuc hanh tat ca vi du

4. Take breaks
   Nghi gap nghi gian

5. Review regularly
   On tap thuong xuyen

6. Experiment freely
   Thuc nghiem tu do

7. Keep notes
   Giu cac ghi chu

8. Share knowledge
   Chia se kien thuc

## Course Objectives Met / Dat duoc Muc tieu Khoa hoc

Upon completion, you will:
- Understand Infrastructure as Code
- Master Terraform fundamentals
- Create reusable modules
- Manage infrastructure at scale
- Implement best practices
- Prepare for real-world projects
- Be ready for Terraform certification

## Support Resources / Tai nguyen Ho tro

- Terraform Documentation: https://www.terraform.io/docs
- HashiCorp Learn: https://learn.hashicorp.com
- Terraform Registry: https://registry.terraform.io
- Community Forums: https://discuss.hashicorp.com

## Final Reminder / Nhan dam Cuoi cung

Progress through this course at your own pace. Each day builds
upon the previous, so don't rush. By day 30, you'll have solid
understanding of Terraform and be ready for production use.

Tien trinh qua khoa hoc nay voi toc do cua ban. Moi ngay xay
dung tren ngay truoc, nen khong can voi vang. Den ngay 30, ban
se co hieu biet vung chac ve Terraform va san sang su dung.

---

Happy Learning! / Hoc tap vui ve!
Hanh trinh Terraform 30 ngay bat dau tai day.
Your Terraform 30-day journey starts here.
