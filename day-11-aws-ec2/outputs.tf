# Day 11: AWS EC2 - Outputs

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.public.id
}

output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.main[*].id
}

output "instance_private_ips" {
  description = "Private IP addresses"
  value       = aws_instance.main[*].private_ip
}

output "instance_public_ips" {
  description = "Public IP addresses"
  value       = aws_instance.main[*].public_ip
}

output "elastic_ips" {
  description = "Elastic IP addresses"
  value       = var.assign_eip ? aws_eip.main[*].public_ip : []
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.ec2.id
}

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.ec2.arn
}

output "instance_details" {
  description = "Summary of instances"
  value = {
    count             = var.instance_count
    instance_type     = var.instance_type
    ami               = data.aws_ami.ubuntu.id
    security_group_id = aws_security_group.ec2.id
  }
}
