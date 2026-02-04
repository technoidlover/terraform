# Terraform 30-Day Learning Journey
# Hành Trình Học Terraform Trong 30 Ngày

## Course Overview / Tổng Quan Khóa Học

This is a comprehensive 30-day program designed to take you from a complete beginner to a proficient Terraform user. Each day includes theory, practical examples, and hands-on labs.

Đây là chương trình 30 ngày toàn diện được thiết kế để đưa bạn từ người mới bắt đầu trở thành người dùng Terraform thành thạo. Mỗi ngày bao gồm lý thuyết, ví dụ thực tế và bài thực hành.

## Prerequisites / Yêu Cầu Tiên Quyết

- Basic understanding of cloud computing concepts
- Familiarity with command line interface
- A computer with internet connection
- Text editor or IDE (VS Code recommended)

- Hiểu biết cơ bản về khái niệm điện toán đám mây
- Quen thuộc với giao diện dòng lệnh
- Máy tính có kết nối Internet
- Trình soạn thảo văn bản hoặc IDE (khuyên nghị VS Code)

## Course Structure / Cấu Trúc Khóa Học

### Week 1: Terraform Fundamentals (Days 1-7)
### Tuần 1: Cơ Bản Về Terraform (Ngày 1-7)

- Day 1: Introduction & Installation / Giới Thiệu Và Cài Đặt
- Day 2: Terraform Basics & HCL Syntax / Cơ Bản Terraform Và Cú Pháp HCL
- Day 3: Providers & Provider Configuration / Providers Và Cấu Hình Provider
- Day 4: Resources & Resource Blocks / Tài Nguyên Và Khối Tài Nguyên
- Day 5: Terraform State Basics / Cơ Bản Về Trạng Thái Terraform
- Day 6: Terraform Commands & Workflow / Các Lệnh Và Quy Trình Làm Việc
- Day 7: Week 1 Review & Practice / Ôn Tập Và Thực Hành Tuần 1

### Week 2: Working with Resources & State (Days 8-14)
### Tuần 2: Làm Việc Với Tài Nguyên Và Trạng Thái (Ngày 8-14)

- Day 8: Input Variables / Biến Đầu Vào
- Day 9: Output Values / Giá Trị Đầu Ra
- Day 10: Local Values & Data Sources / Giá Trị Cục Bộ Và Nguồn Dữ Liệu
- Day 11: State Management Advanced / Quản Lý Trạng Thái Nâng Cao
- Day 12: Remote State & Backends / Trạng Thái Từ Xa Và Backend
- Day 13: Resource Dependencies / Phụ Thuộc Tài Nguyên
- Day 14: Week 2 Review & Practice / Ôn Tập Và Thực Hành Tuần 2

### Week 3: Modules & Advanced Concepts (Days 15-21)
### Tuần 3: Modules Và Khái Niệm Nâng Cao (Ngày 15-21)

- Day 15: Introduction to Modules / Giới Thiệu Về Modules
- Day 16: Creating Custom Modules / Tạo Module Tự Chỉnh
- Day 17: Module Registry & Public Modules / Registry Module Và Module Công Khai
- Day 18: Workspaces / Không Gian Làm Việc
- Day 19: Functions & Expressions / Hàm Và Biểu Thức
- Day 20: Conditional Expressions & Loops / Biểu Thức Điều Kiện Và Vòng Lặp
- Day 21: Week 3 Review & Practice / Ôn Tập Và Thực Hành Tuần 3

### Week 4: Best Practices & Real-world Projects (Days 22-30)
### Tuần 4: Thực Hành Tốt Nhất Và Dự Án Thực Tế (Ngày 22-30)

- Day 22: Terraform Best Practices / Thực Hành Tốt Nhất
- Day 23: Security & Secrets Management / Bảo Mật Và Quản Lý Bí Mật
- Day 24: Testing Terraform Code / Kiểm Tra Mã Terraform
- Day 25: CI/CD with Terraform / CI/CD Với Terraform
- Day 26: Multi-Cloud Strategies / Chiến Lược Đa Đám Mây
- Day 27: Real-world Project Part 1 / Dự Án Thực Tế Phần 1
- Day 28: Real-world Project Part 2 / Dự Án Thực Tế Phần 2
- Day 29: Real-world Project Part 3 / Dự Án Thực Tế Phần 3
- Day 30: Course Review & Next Steps / Ôn Tập Khóa Học Và Bước Tiếp Theo

## How to Use This Course / Cách Sử Dụng Khóa Học Này

1. Follow the days in order - each builds upon previous knowledge
2. Read the documentation in each day's folder
3. Study the example code provided
4. Complete the lab exercises
5. Review and practice regularly

1. Làm theo thứ tự các ngày - mỗi ngày xây dựng trên kiến thức trước đó
2. Đọc tài liệu trong thư mục của mỗi ngày
3. Nghiên cứu mã ví dụ được cung cấp
4. Hoàn thành các bài tập thực hành
5. Ôn tập và thực hành thường xuyên

## Installation Guide / Huong dan Cai dat

### Installing Terraform / Cai dat Terraform

#### Windows:
```powershell
# Download from official website
# Tai xuong tu trang web chinh thuc
# https://www.terraform.io/downloads

# Or use Chocolatey
# Hoac su dung Chocolatey
choco install terraform

# Verify installation
# Xac minh cai dat
terraform --version
```

#### macOS:
```bash
# Using Homebrew
# Su dung Homebrew
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Verify installation
# Xac minh cai dat
terraform --version
```

#### Linux:
```bash
# Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Verify installation
# Xac minh cai dat
terraform --version
```

## Setting Up Your Environment / Thiet lap Moi truong

1. Install a code editor (VS Code recommended)
2. Install Terraform extension for your editor
3. Set up a cloud provider account (AWS, Azure, or GCP)
4. Configure cloud provider credentials
5. Create a workspace folder for your labs

1. Cai dat trinh soan thao ma (khuyen nghi VS Code)
2. Cai dat extension Terraform cho trinh soan thao
3. Thiet lap tai khoan nha cung cap dam may (AWS, Azure, hoac GCP)
4. Cau hinh thong tin xac thuc nha cung cap dam may
5. Tao folder lam viec cho cac bai thuc hanh

## Additional Resources / Tai nguyen Bo sung

- Official Terraform Documentation: https://www.terraform.io/docs
- Terraform Registry: https://registry.terraform.io
- HashiCorp Learn: https://learn.hashicorp.com/terraform
- Community Forums: https://discuss.hashicorp.com

## Support / Ho tro

Each day's folder contains:
- README.md with detailed explanations (bilingual)
- Example Terraform files with comprehensive comments
- Lab exercises with solutions
- Additional resources and tips

Folder cua moi ngay chua:
- README.md voi giai thich chi tiet (song ngu)
- Cac file Terraform mau voi comment day du
- Bai tap thuc hanh voi loi giai
- Tai nguyen bo sung va meo hay

## License / Giay phep

This educational material is provided for learning purposes.
Tai lieu giao duc nay duoc cung cap cho muc dich hoc tap.

---

Start your journey with Day 1!
Bat dau hanh trinh cua ban voi Ngay 1!
