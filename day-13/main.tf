# Resource Dependencies Examples
# Vi du Phu thuoc Tai nguyen

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

# Example 1: Implicit dependency
# Vi du 1: Phu thuoc ngam dinh
# The second resource automatically depends on the first
# Resource thu hai tu dong phu thuoc vao resource dau tien

resource "random_pet" "name" {
  length = 2
}

resource "local_file" "implicit_dep" {
  # Implicit dependency: references random_pet.name
  # Phu thuoc ngam dinh: tham chieu den random_pet.name
  filename = "${path.module}/${random_pet.name.id}.txt"
  content  = "Server name: ${random_pet.name.id}"
}

# Example 2: Explicit dependency
# Vi du 2: Phu thuoc ro rang
# Use when dependency is not through direct reference
# Su dung khi phu thuoc khong thong qua tham chieu truc tiep

resource "local_file" "first" {
  filename = "${path.module}/first.txt"
  content  = "This is created first"
}

resource "local_file" "second" {
  filename = "${path.module}/second.txt"
  content  = "This is created second"

  # Explicit dependency using depends_on
  # Phu thuoc ro rang su dung depends_on
  depends_on = [local_file.first]
}

# Example 3: Chain of dependencies
# Vi du 3: Chuoi phu thuoc

resource "random_integer" "priority" {
  min = 1
  max = 100
}

resource "local_file" "config" {
  # Depends on random_integer
  # Phu thuoc vao random_integer
  filename = "${path.module}/config.txt"
  content  = "Priority: ${random_integer.priority.result}"
}

resource "local_file" "summary" {
  filename = "${path.module}/summary.txt"
  # Depends on both random_integer and local_file.config
  # Phu thuoc vao ca random_integer va local_file.config
  content = <<-EOT
    Configuration Summary
    Tom tat Cau hinh
    ===================
    
    Priority: ${random_integer.priority.result}
    Config File: ${local_file.config.filename}
    
    This file depends on:
    File nay phu thuoc vao:
    - random_integer.priority
    - local_file.config
  EOT

  depends_on = [local_file.config]
}

# Example 4: Multiple dependencies
# Vi du 4: Nhieu phu thuoc

resource "local_file" "dep1" {
  filename = "${path.module}/dependency-1.txt"
  content  = "Dependency 1"
}

resource "local_file" "dep2" {
  filename = "${path.module}/dependency-2.txt"
  content  = "Dependency 2"
}

resource "local_file" "multi_dep" {
  filename = "${path.module}/multi-dependency.txt"
  content  = "This depends on multiple resources"

  # Multiple explicit dependencies
  # Nhieu phu thuoc ro rang
  depends_on = [
    local_file.dep1,
    local_file.dep2
  ]
}

# Output showing dependency relationships
# Output hien thi moi quan he phu thuoc
output "dependency_info" {
  value = {
    implicit = "local_file.implicit_dep depends on random_pet.name"
    explicit = "local_file.second depends on local_file.first"
    chain    = "local_file.summary depends on local_file.config and random_integer.priority"
    multiple = "local_file.multi_dep depends on dep1 and dep2"
  }
}
