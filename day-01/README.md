# Day 1: Introduction to Terraform and Installation
# Ngay 1: Gioi thieu ve Terraform va Cai dat

## Objectives / Muc tieu

By the end of this day, you will:
- Understand what Terraform is and why it's used
- Learn about Infrastructure as Code (IaC) concepts
- Install Terraform on your system
- Verify the installation
- Run your first Terraform command

Vao cuoi ngay nay, ban se:
- Hieu Terraform la gi va tai sao no duoc su dung
- Hoc ve cac khai niem Infrastructure as Code (IaC)
- Cai dat Terraform tren he thong cua ban
- Xac minh cai dat
- Chay lenh Terraform dau tien cua ban

## What is Terraform? / Terraform la gi?

Terraform is an open-source Infrastructure as Code (IaC) tool created by HashiCorp. It allows you to define and provision infrastructure using a declarative configuration language called HashiCorp Configuration Language (HCL).

Terraform la cong cu Infrastructure as Code (IaC) ma nguon mo do HashiCorp tao ra. No cho phep ban dinh nghia va cung cap ha tang su dung ngon ngu cau hinh khai bao goi la HashiCorp Configuration Language (HCL).

### Key Features / Tinh nang Chinh

1. **Declarative Syntax**: You describe what you want, not how to create it
2. **Multi-Cloud Support**: Works with AWS, Azure, GCP, and many other providers
3. **State Management**: Keeps track of your infrastructure
4. **Plan Before Apply**: Preview changes before making them
5. **Modular and Reusable**: Create reusable infrastructure components

1. **Cu phap Khai bao**: Ban mo ta ban muon gi, khong phai cach tao no
2. **Ho tro Da dam may**: Lam viec voi AWS, Azure, GCP va nhieu provider khac
3. **Quan ly Trang thai**: Theo doi ha tang cua ban
4. **Ke hoach Truoc khi Ap dung**: Xem truoc thay doi truoc khi thuc hien
5. **Modular va Co the Tai su dung**: Tao cac thanh phan ha tang co the tai su dung

## Infrastructure as Code (IaC) / Ha tang Duoi dang Ma

Infrastructure as Code is the practice of managing and provisioning infrastructure through code instead of manual processes.

Infrastructure as Code la thuc hanh quan ly va cung cap ha tang thong qua ma thay vi cac quy trinh thu cong.

### Benefits of IaC / Loi ich cua IaC

- **Version Control**: Track changes over time
- **Automation**: Reduce manual errors
- **Consistency**: Same configuration every time
- **Documentation**: Code serves as documentation
- **Collaboration**: Team can work together on infrastructure

- **Kiem soat Phien ban**: Theo doi cac thay doi theo thoi gian
- **Tu dong hoa**: Giam loi thu cong
- **Nhat quan**: Cung cau hinh moi lan
- **Tai lieu**: Ma phuc vu nhu tai lieu
- **Cong tac**: Nhom co the lam viec cung nhau tren ha tang

## Terraform Architecture / Kien truc Terraform

Terraform consists of:

Terraform bao gom:

1. **Terraform Core**: Reads configuration and builds dependency graph
2. **Providers**: Plugins that interact with APIs of services
3. **State**: Records information about managed infrastructure
4. **Configuration Files**: .tf files containing your infrastructure code

1. **Terraform Core**: Doc cau hinh va xay dung do thi phu thuoc
2. **Providers**: Plugin tuong tac voi API cua cac dich vu
3. **State**: Ghi lai thong tin ve ha tang duoc quan ly
4. **Configuration Files**: Cac file .tf chua ma ha tang cua ban

## Installation Steps / Cac buoc Cai dat

### For Windows / Cho Windows

Method 1: Manual Installation
Phuong phap 1: Cai dat Thu cong

1. Download Terraform from https://www.terraform.io/downloads
2. Extract the zip file
3. Add the folder to your PATH environment variable
4. Verify installation

1. Tai Terraform tu https://www.terraform.io/downloads
2. Giai nen file zip
3. Them folder vao bien moi truong PATH
4. Xac minh cai dat

Method 2: Using Chocolatey (Recommended)
Phuong phap 2: Su dung Chocolatey (Khuyen nghi)

```powershell
# Install Chocolatey first if not installed
# Cai dat Chocolatey truoc neu chua cai dat

# Then install Terraform
# Sau do cai dat Terraform
choco install terraform

# Verify
# Xac minh
terraform --version
```

### For macOS / Cho macOS

```bash
# Using Homebrew
# Su dung Homebrew
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Verify
# Xac minh
terraform --version
```

### For Linux / Cho Linux

```bash
# For Ubuntu/Debian
# Cho Ubuntu/Debian
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Verify
# Xac minh
terraform --version
```

## Verifying Installation / Xac minh Cai dat

After installation, verify Terraform is correctly installed:

Sau khi cai dat, xac minh Terraform duoc cai dat dung:

```bash
terraform --version
```

You should see output like:
Ban nen thay ket qua nhu:

```
Terraform v1.x.x
on windows_amd64
```

## Basic Terraform Commands / Cac lenh Terraform Co ban

Here are some basic commands you'll use:
Day la mot so lenh co ban ban se su dung:

```bash
terraform --help          # Show help / Hien thi tro giup
terraform version         # Show version / Hien thi phien ban
terraform init           # Initialize working directory / Khoi tao thu muc lam viec
terraform validate       # Validate configuration / Xac thuc cau hinh
terraform plan          # Show execution plan / Hien thi ke hoach thuc thi
terraform apply         # Apply changes / Ap dung thay doi
terraform destroy       # Destroy infrastructure / Huy ha tang
```

## Lab Exercise / Bai thuc hanh

### Lab 1.1: Installation Verification
### Bai 1.1: Xac minh Cai dat

1. Install Terraform using your preferred method
2. Open terminal/command prompt
3. Run `terraform version`
4. Take a screenshot of the output
5. Run `terraform --help` to see available commands

1. Cai dat Terraform bang phuong phap ban thich
2. Mo terminal/command prompt
3. Chay `terraform version`
4. Chup man hinh ket qua
5. Chay `terraform --help` de xem cac lenh co san

### Lab 1.2: Create Your First Directory Structure
### Bai 1.2: Tao Cau truc Thu muc Dau tien

1. Create a new folder called `terraform-labs`
2. Inside it, create a folder called `day-01-intro`
3. This will be your workspace for today's exercises

1. Tao folder moi ten la `terraform-labs`
2. Ben trong no, tao folder ten la `day-01-intro`
3. Day se la khong gian lam viec cho cac bai tap hom nay

## Key Takeaways / Diem Chinh

- Terraform is an IaC tool for managing infrastructure
- It uses declarative configuration language (HCL)
- It supports multiple cloud providers
- Installation is straightforward on all major platforms
- Basic commands include init, plan, apply, and destroy

- Terraform la cong cu IaC de quan ly ha tang
- No su dung ngon ngu cau hinh khai bao (HCL)
- No ho tro nhieu nha cung cap dam may
- Cai dat don gian tren tat ca cac nen tang chinh
- Cac lenh co ban bao gom init, plan, apply va destroy

## Additional Resources / Tai nguyen Bo sung

- Terraform Official Documentation: https://www.terraform.io/docs
- HashiCorp Learn: https://learn.hashicorp.com/terraform
- Terraform GitHub: https://github.com/hashicorp/terraform

## Next Steps / Buoc tiep theo

Tomorrow (Day 2), we will:
- Learn HCL syntax basics
- Write our first Terraform configuration
- Understand Terraform blocks and structure

Ngay mai (Ngay 2), chung ta se:
- Hoc co ban cu phap HCL
- Viet cau hinh Terraform dau tien
- Hieu cac khoi va cau truc Terraform

## Questions for Review / Cau hoi On tap

1. What does IaC stand for?
2. Name three benefits of using Terraform
3. What command verifies Terraform installation?
4. What are the main components of Terraform architecture?
5. What file extension do Terraform configurations use?

1. IaC la viet tat cua gi?
2. Ke ten ba loi ich cua viec su dung Terraform
3. Lenh nao xac minh cai dat Terraform?
4. Cac thanh phan chinh cua kien truc Terraform la gi?
5. Cac cau hinh Terraform su dung phan mo rong file nao?

---

End of Day 1 / Ket thuc Ngay 1
