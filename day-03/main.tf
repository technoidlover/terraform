# Example: Working with Multiple Providers
# Vi du: Lam viec voi Nhieu Providers

# Terraform configuration block with multiple providers
# Khoi cau hinh Terraform voi nhieu providers
terraform {
  # Minimum Terraform version required
  # Phien ban Terraform toi thieu can thiet
  required_version = ">= 1.0"

  # Define all required providers
  # Dinh nghia tat ca cac provider can thiet
  required_providers {
    # Local provider for file operations
    # Provider local cho cac thao tac file
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }

    # Random provider for generating random values
    # Provider random de tao cac gia tri ngau nhien
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    # Null provider for running provisioners
    # Provider null de chay cac provisioner
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

# Configure the local provider
# Cau hinh provider local
# No additional configuration needed
# Khong can cau hinh bo sung
provider "local" {
}

# Configure the random provider
# Cau hinh provider random
# No additional configuration needed
# Khong can cau hinh bo sung
provider "random" {
}

# Configure the null provider
# Cau hinh provider null
# No additional configuration needed
# Khong can cau hinh bo sung
provider "null" {
}

# Resource: Generate a random pet name
# Tai nguyen: Tao ten thu cung ngau nhien
resource "random_pet" "server_name" {
  # Length of the pet name (number of words)
  # Do dai cua ten thu cung (so tu)
  length = 2

  # Separator between words
  # Ky tu phan cach giua cac tu
  separator = "-"

  # Prefix for the name
  # Tien to cho ten
  prefix = "server"
}

# Resource: Generate a random integer
# Tai nguyen: Tao so nguyen ngau nhien
resource "random_integer" "port" {
  # Minimum value
  # Gia tri toi thieu
  min = 8000

  # Maximum value
  # Gia tri toi da
  max = 9000
}

# Resource: Create a file with random content
# Tai nguyen: Tao file voi noi dung ngau nhien
resource "local_file" "server_config" {
  # File path
  # Duong dan file
  filename = "${path.module}/server-config.txt"

  # Content using interpolation from random resources
  # Noi dung su dung noi suy tu cac tai nguyen ngau nhien
  content = <<-EOT
    Server Configuration
    Cau hinh May chu
    ====================
    
    Server Name: ${random_pet.server_name.id}
    Ten May chu: ${random_pet.server_name.id}
    
    Port Number: ${random_integer.port.result}
    So Cong: ${random_integer.port.result}
    
    Generated at: ${timestamp()}
    Tao luc: ${timestamp()}
    
    Provider Information:
    Thong tin Provider:
    - Local Provider: ${local_file.server_config.filename}
    - Random Provider Version: 3.x
    - Null Provider: Available for provisioning
  EOT

  # File permissions
  # Quyen file
  file_permission = "0644"
}

# Resource: Null resource for demonstration
# Tai nguyen: Tai nguyen null de minh hoa
# Null resources don't create anything but can run provisioners
# Tai nguyen null khong tao gi nhung co the chay provisioners
resource "null_resource" "example" {
  # This resource will be recreated if server name changes
  # Tai nguyen nay se duoc tao lai neu ten may chu thay doi
  triggers = {
    server_name = random_pet.server_name.id
    port        = random_integer.port.result
  }

  # Dependencies - ensure file is created first
  # Phu thuoc - dam bao file duoc tao truoc
  depends_on = [local_file.server_config]
}

# Output: Display the generated server name
# Dau ra: Hien thi ten may chu duoc tao
output "server_name" {
  description = "The randomly generated server name"
  value       = random_pet.server_name.id
}

# Output: Display the generated port number
# Dau ra: Hien thi so cong duoc tao
output "port_number" {
  description = "The randomly generated port number"
  value       = random_integer.port.result
}

# Output: Display the full server address
# Dau ra: Hien thi dia chi may chu day du
output "server_address" {
  description = "Complete server address"
  value       = "${random_pet.server_name.id}:${random_integer.port.result}"
}
