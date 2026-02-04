# Day 2: Terraform Basics and HCL Syntax
# Ngay 2: Co ban ve Terraform va Cu phap HCL

## Objectives / Muc tieu

By the end of this day, you will:
- Understand HCL (HashiCorp Configuration Language) syntax
- Learn about Terraform block structure
- Write your first Terraform configuration
- Understand the Terraform workflow
- Initialize and validate your first configuration

Vao cuoi ngay nay, ban se:
- Hieu cu phap HCL (HashiCorp Configuration Language)
- Hoc ve cau truc khoi Terraform
- Viet cau hinh Terraform dau tien cua ban
- Hieu quy trinh lam viec Terraform
- Khoi tao va xac thuc cau hinh dau tien cua ban

## HCL Syntax Basics / Co ban Cu phap HCL

HCL is designed to be both human-readable and machine-friendly. It uses a simple, declarative syntax.

HCL duoc thiet ke de vua de doc cho con nguoi vua thuan tien cho may. No su dung cu phap khai bao don gian.

### Basic Syntax Elements / Cac thanh phan Cu phap Co ban

1. **Blocks**: Containers for configuration
2. **Arguments**: Assign values to names
3. **Expressions**: Represent values
4. **Comments**: Documentation within code

1. **Blocks**: Cac container cho cau hinh
2. **Arguments**: Gan gia tri cho ten
3. **Expressions**: Dai dien cho gia tri
4. **Comments**: Tai lieu ben trong ma

### Block Syntax / Cu phap Khoi

```hcl
block_type "label1" "label2" {
  argument1 = value1
  argument2 = value2
  
  nested_block {
    argument3 = value3
  }
}
```

### Comments / Chu thich

```hcl
# Single line comment
# Chu thich mot dong

// Also a single line comment
// Cung la chu thich mot dong

/*
Multi-line comment
Chu thich
nhieu dong
*/
```

## Terraform Configuration Structure / Cau truc Cau hinh Terraform

A typical Terraform project contains:
Mot du an Terraform dien hinh chua:

1. **main.tf**: Primary configuration file
2. **variables.tf**: Input variable definitions
3. **outputs.tf**: Output value definitions
4. **terraform.tfvars**: Variable value assignments
5. **providers.tf**: Provider configurations

1. **main.tf**: File cau hinh chinh
2. **variables.tf**: Dinh nghia bien dau vao
3. **outputs.tf**: Dinh nghia gia tri dau ra
4. **terraform.tfvars**: Gan gia tri bien
5. **providers.tf**: Cau hinh provider

## Terraform Block / Khoi Terraform

The terraform block configures Terraform behavior:
Khoi terraform cau hinh hanh vi Terraform:

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}
```

## Provider Block / Khoi Provider

Providers are plugins that interact with APIs:
Providers la cac plugin tuong tac voi API:

```hcl
provider "provider_name" {
  # Provider-specific configuration
  # Cau hinh cu the cua provider
}
```

## Resource Block / Khoi Resource

Resources are the most important element:
Resources la thanh phan quan trong nhat:

```hcl
resource "resource_type" "resource_name" {
  argument1 = "value1"
  argument2 = "value2"
}
```

## Data Types / Kieu Du lieu

HCL supports several data types:
HCL ho tro mot so kieu du lieu:

1. **String**: Text values
2. **Number**: Numeric values
3. **Bool**: true or false
4. **List**: Ordered collection
5. **Map**: Collection of key-value pairs
6. **Set**: Unordered collection of unique values

```hcl
string_example  = "Hello Terraform"
number_example  = 42
bool_example    = true
list_example    = ["item1", "item2", "item3"]
map_example     = {
  key1 = "value1"
  key2 = "value2"
}
```

## Terraform Workflow / Quy trinh Lam viec Terraform

The basic workflow consists of:
Quy trinh co ban bao gom:

1. **Write**: Author infrastructure code
2. **Initialize**: Download required providers
3. **Plan**: Preview changes
4. **Apply**: Create/update infrastructure
5. **Destroy**: Remove infrastructure when done

1. **Write**: Viet ma ha tang
2. **Initialize**: Tai cac provider can thiet
3. **Plan**: Xem truoc thay doi
4. **Apply**: Tao/cap nhat ha tang
5. **Destroy**: Xoa ha tang khi hoan thanh

### Command Details / Chi tiet Lenh

```bash
# Initialize working directory
# Khoi tao thu muc lam viec
terraform init

# Validate configuration syntax
# Xac thuc cu phap cau hinh
terraform validate

# Format code to canonical style
# Dinh dang ma theo phong cach chuan
terraform fmt

# Show execution plan
# Hien thi ke hoach thuc thi
terraform plan

# Apply changes
# Ap dung thay doi
terraform apply

# Destroy infrastructure
# Huy ha tang
terraform destroy
```

## Lab Exercises / Bai thuc hanh

### Lab 2.1: First Terraform Configuration
### Bai 2.1: Cau hinh Terraform Dau tien

See the `lab-2.1-first-config` folder for:
- Complete configuration files
- Step-by-step instructions
- Expected outputs

Xem folder `lab-2.1-first-config` de co:
- Cac file cau hinh day du
- Huong dan tung buoc
- Ket qua mong doi

### Lab 2.2: Understanding Terraform Workflow
### Bai 2.2: Hieu Quy trinh Lam viec Terraform

See the `lab-2.2-workflow` folder for:
- Workflow demonstration
- Command practice
- Output analysis

Xem folder `lab-2.2-workflow` de co:
- Minh hoa quy trinh lam viec
- Thuc hanh lenh
- Phan tich ket qua

## Key Takeaways / Diem Chinh

- HCL uses a simple, block-based syntax
- Terraform configurations are organized in .tf files
- The basic workflow is: init, plan, apply
- Always validate and format your code
- Use comments to document your infrastructure

- HCL su dung cu phap don gian dua tren khoi
- Cac cau hinh Terraform duoc to chuc trong cac file .tf
- Quy trinh co ban la: init, plan, apply
- Luon xac thuc va dinh dang ma cua ban
- Su dung chu thich de tai lieu ha tang cua ban

## Common Mistakes to Avoid / Loi Thuong gap Can Tranh

1. Not running `terraform init` after adding providers
2. Skipping `terraform plan` before apply
3. Not using version constraints for providers
4. Forgetting to commit .terraform.lock.hcl
5. Hardcoding sensitive values

1. Khong chay `terraform init` sau khi them providers
2. Bo qua `terraform plan` truoc khi apply
3. Khong su dung rang buoc phien ban cho providers
4. Quen commit .terraform.lock.hcl
5. Hardcode cac gia tri nhay cam

## Best Practices / Thuc hanh Tot nhat

- Always use version control (Git)
- Keep configurations in separate files by purpose
- Use meaningful resource names
- Add comments to explain complex logic
- Run `terraform fmt` before committing

- Luon su dung kiem soat phien ban (Git)
- Giu cau hinh trong cac file rieng biet theo muc dich
- Su dung ten tai nguyen co y nghia
- Them chu thich de giai thich logic phuc tap
- Chay `terraform fmt` truoc khi commit

## Questions for Review / Cau hoi On tap

1. What does HCL stand for?
2. Name the three main components of a Terraform block
3. What is the purpose of `terraform init`?
4. What command validates your configuration syntax?
5. What is the difference between `plan` and `apply`?

1. HCL la viet tat cua gi?
2. Ke ten ba thanh phan chinh cua khoi Terraform
3. Muc dich cua `terraform init` la gi?
4. Lenh nao xac thuc cu phap cau hinh cua ban?
5. Su khac biet giua `plan` va `apply` la gi?

## Next Steps / Buoc tiep theo

Tomorrow (Day 3), we will:
- Learn about Terraform providers in detail
- Configure multiple providers
- Work with provider versions and aliases
- Understand provider authentication

Ngay mai (Ngay 3), chung ta se:
- Hoc chi tiet ve cac provider Terraform
- Cau hinh nhieu provider
- Lam viec voi phien ban va ban sao provider
- Hieu xac thuc provider

---

End of Day 2 / Ket thuc Ngay 2
