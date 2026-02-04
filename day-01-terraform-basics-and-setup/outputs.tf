# Day 1: Terraform Configuration - Outputs
# This file defines values that will be displayed to the user after terraform apply
# Outputs are useful for displaying important information about created resources

# EC2 Instance ID output
# The instance ID uniquely identifies the EC2 instance in AWS
output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.hello_world.id
}

# EC2 Instance Public IP
# The public IP address used to connect to the instance from the internet
output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.hello_world.public_ip
}

# EC2 Instance Public DNS
# DNS hostname that can be used to connect to the instance
output "instance_public_dns" {
  description = "The public DNS name of the EC2 instance"
  value       = aws_instance.hello_world.public_dns
}

# EC2 Instance Private IP
# The private IP address within the VPC
output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.hello_world.private_ip
}

# Security Group ID output
# The unique identifier of the security group
output "security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.hello_world.id
}

# Security Group Name output
# The name of the security group
output "security_group_name" {
  description = "The name of the created security group"
  value       = aws_security_group.hello_world.name
}

# Combined information output
# A formatted string with all important connection information
output "connection_info" {
  description = "Connection information for the EC2 instance"
  value = {
    instance_id    = aws_instance.hello_world.id
    public_ip      = aws_instance.hello_world.public_ip
    public_dns     = aws_instance.hello_world.public_dns
    security_group = aws_security_group.hello_world.id
  }
}

# SSH Command output
# A ready-to-use SSH command for connecting to the instance
# Note: Assumes you have the default key pair or appropriate key
output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i /path/to/key.pem ec2-user@${aws_instance.hello_world.public_ip}"
}

# HTTP Connection URL output
# A URL to access the web server running on the instance
output "http_url" {
  description = "HTTP URL to access the web server"
  value       = "http://${aws_instance.hello_world.public_dns}"
}

# Instance availability zone
# The specific availability zone where the instance is running
output "instance_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.hello_world.availability_zone
}

# Instance state
# Current state of the instance (running, stopped, etc.)
output "instance_state" {
  description = "Current state of the EC2 instance"
  value       = aws_instance.hello_world.instance_state
}

# All instance details summary
# A comprehensive summary of the created resources
output "summary" {
  description = "Summary of created resources"
  value = {
    message     = "EC2 instance created successfully!"
    region      = var.aws_region
    instance    = aws_instance.hello_world.id
    instance_ip = aws_instance.hello_world.public_ip
    sg_id       = aws_security_group.hello_world.id
    created_at  = aws_instance.hello_world.launch_time
  }
}
