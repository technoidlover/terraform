# Working with Terraform State
# Lam viec voi Trang thai Terraform

terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Create random resources to demonstrate state
# Tao cac resource ngau nhien de minh hoa state
resource "random_pet" "server" {
  length    = 2
  separator = "-"
}

resource "random_integer" "count" {
  min = 1
  max = 10
}

# Create files that will be tracked in state
# Tao cac file se duoc theo doi trong state
resource "local_file" "state_demo" {
  count    = random_integer.count.result
  filename = "${path.module}/state-file-${count.index}.txt"
  content  = <<-EOT
    File Index: ${count.index}
    Chi so File: ${count.index}
    
    Server Name: ${random_pet.server.id}
    Ten May chu: ${random_pet.server.id}
    
    This file is tracked in Terraform state
    File nay duoc theo doi trong trang thai Terraform
  EOT
}

# Output to verify state tracking
# Dau ra de xac minh theo doi state
output "files_created" {
  value = length(local_file.state_demo)
}

output "server_identifier" {
  value = random_pet.server.id
}
