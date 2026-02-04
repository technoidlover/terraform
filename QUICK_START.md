# Terraform 30-Day Course - Quick Start Guide
# Khóa Học Terraform 30 Ngày - Hướng Dẫn Bắt Đầu Nhanh Chóng

## Getting Started / Bắt Đầu

### 1. Prerequisites / Tiên Quyết

- Terraform installed (version 1.0+)
- AWS account (or another cloud provider)
- Text editor (VS Code recommended)
- Git for version control
- Basic command line knowledge

### 2. Directory Structure / Cấu Trúc Thư Mục

```
e:\terraform\
├── README.md                    # Main overview / Tổng Quan Chính
├── QUICK_START.md              # This file / Tập Tin Này
├── day-01/                      # Day 1 materials
│   ├── README.md
│   └── example.tf
├── day-02/                      # Day 2 materials
│   ├── README.md
│   ├── main.tf
│   └── lab-2.1-first-config/
├── ... (days 3-30)
└── LEARNING_PATH.md            # Learning path / Đường Dẫn Học Tập
```

### 3. How to Use Each Day / Cách Sử Dụng Mỗi Ngày

1. **Read the README.md**
   - Contains theory and concepts
   - Chứa lý thuyết và khái niệm

2. **Study the Code**
   - Review example.tf or main.tf
   - Mã được ghi chú đầy đủ
   - All comments in bilingual format
   - Các ghi chú song ngữ

3. **Complete Lab Exercises**
   - Follow step-by-step instructions
   - Làm theo hướng dẫn chi tiết
   - Practice commands
   - Thực hành các lệnh

4. **Review Outputs**
   - Understand results
   - Compare with expectations
   - Xem xét kết quả

### 4. Learning Tips / Mẹo Học Tập

- Don't just read, practice hands-on
- Không chỉ đọc, thực hành tay
- Type commands yourself
- Tự nhập các lệnh
- Experiment with examples
- Thử nghiệm với các ví dụ
- Take notes
- Ghi chú quan trọng
- Ask questions
- Đặt câu hỏi

### 5. Daily Schedule / Lịch Trình Hàng Ngày

- **1-2 hours per day** recommended
- Read README: 20-30 minutes
- Study code: 20-30 minutes
- Practice labs: 20-40 minutes
- Review: 10 minutes

### 6. Week-by-Week Progression / Tiến Trình Từng Tuần

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

### 7. Common Commands / Các Lệnh Thường Gặp

```bash
# Before working with a day's code
# Trước khi làm việc với mã của ngày đó

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

### 8. Troubleshooting / Khắc Phục Sự Cố

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

### 9. Getting Help / Nhận Trợ Giúp

Each day's README includes:
- Detailed explanations in both languages
- Example code with comments
- Common issues and solutions
- Additional resources

### 10. Next Steps After Course / Sau Khóa Học

1. Review all 30 days
2. Build your own project
3. Practice with real cloud provider
4. Join community
5. Study advanced topics
6. Take certification exam

## File Organization / Tổ Chức Tập Tin

Each day folder contains:
- **README.md** - Theory and objectives
- **main.tf or example.tf** - Working code examples
- **terraform.tfvars** - Sample variable values
- **lab-X.X-name/** - Lab exercises with instructions

## Bilingual Content / Nội Dung Song Ngữ

All materials are in both:
- English / Tiếng Anh
- Vietnamese / Tiếng Việt

No emojis or icons are used / Không sử dụng emoji hoặc icon

Comments in code explain:
- What the code does / Mã làm gì
- Why it's written that way / Tại sao viết như vậy
- How to use it / Cách sử dụng

## Tips for Success / Mẹo Thành Công

1. Follow the days in order
   Làm theo thứ tự các ngày

2. Don't skip content
   Không bỏ qua nội dung

3. Practice all examples
   Thực hành tất cả ví dụ

4. Take breaks
   Nghỉ giữa các giờ

5. Review regularly
   Ôn tập thường xuyên

6. Experiment freely
   Thử nghiệm tự do

7. Keep notes
   Giữ các ghi chú

8. Share knowledge
   Chia sẻ kiến thức

## Course Objectives Met / Đạt Được Mục Tiêu Khóa Học

Upon completion, you will:
- Understand Infrastructure as Code
- Master Terraform fundamentals
- Create reusable modules
- Manage infrastructure at scale
- Implement best practices
- Prepare for real-world projects
- Be ready for Terraform certification

## Support Resources / Tài Nguyên Hỗ Trợ

- Terraform Documentation: https://www.terraform.io/docs
- HashiCorp Learn: https://learn.hashicorp.com
- Terraform Registry: https://registry.terraform.io
- Community Forums: https://discuss.hashicorp.com

## Final Reminder / Nhắc Nhở Cuối Cùng

Progress through this course at your own pace. Each day builds
upon the previous, so don't rush. By day 30, you'll have solid
understanding of Terraform and be ready for production use.

Tiến trình qua khóa học này với tốc độ của bạn. Mỗi ngày xây
dựng trên ngày trước, nên không cần vội vàng. Đến ngày 30, bạn
sẽ có hiểu biết vững chắc về Terraform và sẵn sàng sử dụng.

---

Happy Learning! / Học tập vui vẻ!
Hành Trình Terraform 30 Ngày Bắt Đầu Tại Đây.
Your Terraform 30-day journey starts here.
