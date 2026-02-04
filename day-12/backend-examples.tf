# Remote Backend Configuration Examples
# Vi du Cau hinh Backend Remote

# Example 1: Local backend (default)
# Vi du 1: Backend local (mac dinh)
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# Example 2: S3 backend (AWS)
# Vi du 2: Backend S3 (AWS)
# terraform {
#   backend "s3" {
#     # S3 bucket name for state storage
#     # Ten bucket S3 de luu tru state
#     bucket = "my-terraform-state-bucket"
#     
#     # Path within bucket
#     # Duong dan trong bucket
#     key    = "environments/dev/terraform.tfstate"
#     
#     # AWS region
#     # Vung AWS
#     region = "us-east-1"
#     
#     # DynamoDB table for state locking
#     # Bang DynamoDB de khoa state
#     dynamodb_table = "terraform-state-locks"
#     
#     # Encrypt state file
#     # Ma hoa file state
#     encrypt = true
#   }
# }

# Example 3: Azure Storage backend
# Vi du 3: Backend Azure Storage
# terraform {
#   backend "azurerm" {
#     # Storage account name
#     # Ten tai khoan luu tru
#     storage_account_name = "mystorageaccount"
#     
#     # Container name
#     # Ten container
#     container_name       = "tfstate"
#     
#     # State file name
#     # Ten file state
#     key                  = "prod.terraform.tfstate"
#     
#     # Resource group
#     # Nhom tai nguyen
#     resource_group_name  = "terraform-rg"
#   }
# }

# Example 4: GCS backend (Google Cloud)
# Vi du 4: Backend GCS (Google Cloud)
# terraform {
#   backend "gcs" {
#     # Bucket name
#     # Ten bucket
#     bucket  = "my-terraform-state"
#     
#     # Path to state file
#     # Duong dan den file state
#     prefix  = "terraform/state"
#   }
# }

# Example 5: Terraform Cloud backend
# Vi du 5: Backend Terraform Cloud
# terraform {
#   cloud {
#     # Organization name
#     # Ten to chuc
#     organization = "my-org"
#     
#     # Workspace configuration
#     # Cau hinh workspace
#     workspaces {
#       name = "my-workspace"
#     }
#   }
# }
