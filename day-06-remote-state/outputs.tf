# Day 6: Remote State and Collaboration - Outputs

output "state_bucket_name" {
  description = "Name of S3 bucket for state storage"
  value       = aws_s3_bucket.terraform_state.id
}

output "state_bucket_arn" {
  description = "ARN of state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "locks_table_name" {
  description = "Name of DynamoDB table for state locks"
  value       = aws_dynamodb_table.terraform_locks.name
}

output "locks_table_arn" {
  description = "ARN of locks table"
  value       = aws_dynamodb_table.terraform_locks.arn
}

output "terraform_role_arn" {
  description = "ARN of IAM role for Terraform execution"
  value       = aws_iam_role.terraform_role.arn
}

output "terraform_role_name" {
  description = "Name of IAM role for Terraform"
  value       = aws_iam_role.terraform_role.name
}

output "backend_config" {
  description = "Backend configuration for remote state"
  value = {
    bucket         = aws_s3_bucket.terraform_state.id
    key            = "day6/terraform.tfstate"
    region         = var.aws_region
    encrypt        = true
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
  }
  sensitive = false
}

output "setup_instructions" {
  description = "Instructions for setting up remote state"
  value = <<-EOT
    To use remote state, add this backend configuration to your main.tf:

    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.terraform_state.id}"
        key            = "day6/terraform.tfstate"
        region         = "${var.aws_region}"
        encrypt        = true
        dynamodb_table = "${aws_dynamodb_table.terraform_locks.name}"
      }
    }

    Then run:
    terraform init
  EOT
}
