# Terraform 30-Day Learning Journey
# Hanh trinh hoc Terraform trong 30 ngay

## Course Overview / Tong quan khoa hoc

This is a comprehensive 30-day program designed to take you from a complete beginner to a proficient Terraform user. Each day includes theory, practical examples, and hands-on labs.

Day la chuong trinh 30 ngay toan dien duoc thiet ke de dua ban tu nguoi moi bat dau tro thanh nguoi dung Terraform thao thao. Moi ngay bao gom ly thuyet, vi du thuc te va bai thuc hanh.

## Prerequisites / Yeu cau tien quyet

- Basic understanding of cloud computing concepts
- Familiarity with command line interface
- A computer with internet connection
- Text editor or IDE (VS Code recommended)

- Hieu biet co ban ve khai niem dien toan dam may
- Quen thuoc voi giao dien dong lenh
- May tinh co ket noi internet
- Trinh soan thao van ban hoac IDE (khuyen nghi VS Code)

## Course Structure / Cau truc khoa hoc

### Week 1: Terraform Fundamentals (Days 1-7)
### Tuan 1: Co ban ve Terraform (Ngay 1-7)

- Day 1: Introduction & Installation / Gioi thieu va Cai dat
- Day 2: Terraform Basics & HCL Syntax / Co ban Terraform va Cu phap HCL
- Day 3: Providers & Provider Configuration / Providers va Cau hinh Provider
- Day 4: Resources & Resource Blocks / Tai nguyen va Khoi Tai nguyen
- Day 5: Terraform State Basics / Co ban ve Trang thai Terraform
- Day 6: Terraform Commands & Workflow / Cac lenh va Quy trinh lam viec
- Day 7: Week 1 Review & Practice / On tap va Thuc hanh Tuan 1

### Week 2: Working with Resources & State (Days 8-14)
### Tuan 2: Lam viec voi Tai nguyen va Trang thai (Ngay 8-14)

- Day 8: Input Variables / Bien dau vao
- Day 9: Output Values / Gia tri dau ra
- Day 10: Local Values & Data Sources / Gia tri Cuc bo va Nguon Du lieu
- Day 11: State Management Advanced / Quan ly Trang thai Nang cao
- Day 12: Remote State & Backends / Trang thai Tu xa va Backend
- Day 13: Resource Dependencies / Phu thuoc Tai nguyen
- Day 14: Week 2 Review & Practice / On tap va Thuc hanh Tuan 2

### Week 3: Modules & Advanced Concepts (Days 15-21)
### Tuan 3: Modules va Khai niem Nang cao (Ngay 15-21)

- Day 15: Introduction to Modules / Gioi thieu ve Modules
- Day 16: Creating Custom Modules / Tao Module Tu chinh
- Day 17: Module Registry & Public Modules / Registry Module va Module Cong khai
- Day 18: Workspaces / Khong gian lam viec
- Day 19: Functions & Expressions / Ham va Bieu thuc
- Day 20: Conditional Expressions & Loops / Bieu thuc Dieu kien va Vong lap
- Day 21: Week 3 Review & Practice / On tap va Thuc hanh Tuan 3

### Week 4: Best Practices & Real-world Projects (Days 22-30)
### Tuan 4: Thuc hanh Tot nhat va Du an Thuc te (Ngay 22-30)

- Day 22: Terraform Best Practices / Thuc hanh Tot nhat
- Day 23: Security & Secrets Management / Bao mat va Quan ly Bi mat
- Day 24: Testing Terraform Code / Kiem tra Ma Terraform
- Day 25: CI/CD with Terraform / CI/CD voi Terraform
- Day 26: Multi-Cloud Strategies / Chien luoc Da dam may
- Day 27: Real-world Project Part 1 / Du an Thuc te Phan 1
- Day 28: Real-world Project Part 2 / Du an Thuc te Phan 2
- Day 29: Real-world Project Part 3 / Du an Thuc te Phan 3
- Day 30: Course Review & Next Steps / On tap Khoa hoc va Buoc tiep theo

## How to Use This Course / Cach su dung khoa hoc nay

1. Follow the days in order - each builds upon previous knowledge
2. Read the documentation in each day's folder
3. Study the example code provided
4. Complete the lab exercises
5. Review and practice regularly

1. Lam theo thu tu cac ngay - moi ngay xay dung tren kien thuc truoc do
2. Doc tai lieu trong folder cua moi ngay
3. Nghien cuu code mau duoc cung cap
4. Hoan thanh cac bai thuc hanh
5. On tap va thuc hanh thuong xuyen

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
