# Day 15: AWS IAM - Outputs

output "developer_usernames" {
  description = "List of developer usernames"
  value       = aws_iam_user.developers[*].name
}

output "developers_group_arn" {
  description = "ARN of developers group"
  value       = aws_iam_group.developers.arn
}

output "developer_policy_arn" {
  description = "ARN of developer policy"
  value       = aws_iam_policy.developer_policy.arn
}

output "ec2_role_arn" {
  description = "ARN of EC2 role"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "Name of EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.name
}

output "lambda_role_arn" {
  description = "ARN of Lambda role"
  value       = aws_iam_role.lambda_role.arn
}

output "iam_summary" {
  description = "Summary of IAM resources"
  value = {
    developers_group       = aws_iam_group.developers.name
    developers_count       = length(aws_iam_user.developers)
    ec2_role              = aws_iam_role.ec2_role.name
    lambda_role           = aws_iam_role.lambda_role.name
    password_policy       = var.enforce_password_policy
    access_keys_created   = var.create_access_keys
  }
}
