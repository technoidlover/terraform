# Day 3: Variables and Outputs - Outputs

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.main[*].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.main.id
}

output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_instance.main[*].id
}

output "instance_private_ips" {
  description = "List of private IP addresses of instances"
  value       = aws_instance.main[*].private_ip
}

output "instance_public_ips" {
  description = "List of public IP addresses of instances"
  value       = aws_instance.main[*].public_ip
}

output "ami_id" {
  description = "AMI ID used for instances"
  value       = data.aws_ami.latest_ubuntu.id
}

output "availability_zones" {
  description = "List of available zones in the region"
  value       = data.aws_availability_zones.available.names
}

output "network_summary" {
  description = "Summary of network configuration"
  value = {
    vpc_id             = aws_vpc.main.id
    vpc_cidr           = aws_vpc.main.cidr_block
    subnets            = length(aws_subnet.main)
    instances          = var.instance_count
    security_group_id  = aws_security_group.main.id
    environment        = var.environment
  }
}
