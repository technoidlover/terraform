# Resource Examples with Meta-Arguments
# Vi du Resource voi Meta-Arguments

terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Example 1: Basic resource
# Vi du 1: Resource co ban
resource "local_file" "basic" {
  filename = "${path.module}/basic-file.txt"
  content  = "This is a basic resource\nDay la mot resource co ban"
}

# Example 2: Using count meta-argument
# Vi du 2: Su dung meta-argument count
resource "local_file" "multiple_files" {
  # Create 3 files
  # Tao 3 files
  count = 3

  filename = "${path.module}/file-${count.index}.txt"
  content  = "This is file number ${count.index}\nDay la file so ${count.index}"
}

# Example 3: Using for_each meta-argument
# Vi du 3: Su dung meta-argument for_each
resource "local_file" "named_files" {
  # Create files for each environment
  # Tao files cho moi moi truong
  for_each = toset(["dev", "staging", "prod"])

  filename = "${path.module}/${each.key}-config.txt"
  content  = "Configuration for ${each.key} environment\nCau hinh cho moi truong ${each.key}"
}

# Example 4: Using depends_on
# Vi du 4: Su dung depends_on
resource "local_file" "dependency_example" {
  filename = "${path.module}/dependent-file.txt"
  content  = "This file depends on basic file"

  # Explicit dependency
  # Phu thuoc ro rang
  depends_on = [local_file.basic]
}

# Example 5: Using lifecycle
# Vi du 5: Su dung lifecycle
resource "local_file" "lifecycle_example" {
  filename = "${path.module}/lifecycle-file.txt"
  content  = "This file has lifecycle rules\nFile nay co cac quy tac lifecycle"

  # Lifecycle configuration
  # Cau hinh lifecycle
  lifecycle {
    # Prevent accidental deletion
    # Ngan chan xoa nham
    prevent_destroy = false

    # Create new resource before destroying old
    # Tao resource moi truoc khi huy cu
    create_before_destroy = true

    # Ignore changes to specific attributes
    # Bo qua thay doi doi voi thuoc tinh cu the
    ignore_changes = [
      content
    ]
  }
}

# Output values
# Gia tri dau ra
output "basic_file_path" {
  value = local_file.basic.filename
}

output "multiple_files_count" {
  value = length(local_file.multiple_files)
}

output "named_files_list" {
  value = [for f in local_file.named_files : f.filename]
}
