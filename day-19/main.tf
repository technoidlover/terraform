# Functions and Expressions Examples
# Ví Dụ Hàm Và Biểu Thức

terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Variables for demonstration
# Biến để minh hoạ
variable "environments" {
  type    = list(string)
  default = ["dev", "staging", "prod"]
}

variable "tags_list" {
  type = list(map(string))
  default = [
    { name = "web", tier = "frontend" },
    { name = "api", tier = "backend" },
    { name = "db", tier = "database" }
  ]
}

# String Functions Examples
# Ví Dụ Hàm Chuỗi
locals {
  # String manipulation
  # Thao tác chuỗi
  original_name = "my-application"
  upper_name    = upper(local.original_name)
  title_name    = title(replace(local.original_name, "-", " "))

  # String formatting
  # Định dạng chuỗi
  formatted = format("Server-%03d", 42)

  # String splitting and joining
  # Chia và nối chuỗi
  parts  = split("-", local.original_name)
  joined = join("_", local.parts)
}

# Collection Functions Examples
# Ví Dụ Hàm Thu Tập
locals {
  # Length and contains
  # Độ dài và chứa
  env_count = length(var.environments)
  has_prod  = contains(var.environments, "prod")

  # List operations
  # Thao tác danh sách
  first_env   = var.environments[0]
  last_env    = var.environments[length(var.environments) - 1]
  sorted_envs = sort(var.environments)

  # Map operations
  # Thao tác map
  tag_names     = [for tag in var.tags_list : tag.name]
  frontend_tags = [for tag in var.tags_list : tag if tag.tier == "frontend"]
}

# Numeric Functions Examples
# Ví Dụ Hàm Số
locals {
  numbers = [5, 10, 15, 20, 25]

  # Get minimum and maximum values from list
  # Lấy giá trị nhỏ nhất và lớn nhất từ danh sách
  min_value = min(local.numbers...)
  max_value = max(local.numbers...)

  # Calculations
  # Tính toán
  result = ceil(10.3)
}

# Date/Time Functions Examples
# Vi du Ham Ngay/Gio
locals {
  current_time   = timestamp()
  formatted_time = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
}

# Create file demonstrating all functions
# Tao file minh hoa tat ca cac ham
resource "local_file" "functions_demo" {
  filename = "${path.module}/functions-demo.txt"
  content  = <<-EOT
    Terraform Functions Demonstration
    Minh hoa Ham Terraform
    =====================================
    
    STRING FUNCTIONS / HAM CHUOI:
    Original: ${local.original_name}
    Uppercase: ${local.upper_name}
    Title Case: ${local.title_name}
    Formatted: ${local.formatted}
    Joined: ${local.joined}
    
    COLLECTION FUNCTIONS / HAM THU TAP:
    Environment Count: ${local.env_count}
    Has Production: ${local.has_prod}
    First Environment: ${local.first_env}
    Last Environment: ${local.last_env}
    Sorted: ${join(", ", local.sorted_envs)}
    Tag Names: ${join(", ", local.tag_names)}
    
    NUMERIC FUNCTIONS / HAM SO:
    Numbers: ${join(", ", [for n in local.numbers : tostring(n)])}
    Minimum: ${local.min_value}
    Maximum: ${local.max_value}
    Ceil(10.3): ${local.result}
    
    DATE/TIME FUNCTIONS / HAM NGAY/GIO:
    Timestamp: ${local.current_time}
    Formatted: ${local.formatted_time}
    
    ENCODING FUNCTIONS / HAM MA HOA:
    JSON: ${jsonencode({ name = "example", value = 123 })}
    Base64: ${base64encode("Hello Terraform")}
  EOT
}

# Output demonstrating function results
# Output minh hoa ket qua ham
output "string_functions" {
  value = {
    upper     = local.upper_name
    formatted = local.formatted
    joined    = local.joined
  }
}

output "collection_functions" {
  value = {
    count     = local.env_count
    has_prod  = local.has_prod
    tag_names = local.tag_names
  }
}

output "numeric_functions" {
  value = {
    min = local.min_value
    max = local.max_value
  }
}
