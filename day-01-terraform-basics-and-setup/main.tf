# Day 1: Terraform Configuration - Main
# This file contains the primary resource definitions and provider configuration

# Required providers and Terraform version specification
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider
# This tells Terraform to use AWS as the cloud provider and specifies the region
provider "aws" {
  region = var.aws_region

  # Optional: Add default tags to all resources
  default_tags {
    tags = {
      Course      = "Terraform30Days"
      Day         = "Day1"
      Environment = "Learning"
      CreatedBy   = "Terraform"
    }
  }
}

# AWS Security Group
# This resource creates a security group that controls inbound and outbound traffic
resource "aws_security_group" "hello_world" {
  name        = "hello-world-sg"
  description = "Security group for Day 1 Hello World example"

  # VPC ID is left unspecified, so it will use the default VPC
  # You can explicitly set vpc_id if using a non-default VPC

  # Egress (outbound) rule: Allow all outbound traffic
  # This rule permits any traffic leaving the security group
  egress {
    from_port   = 0           # All ports
    to_port     = 0           # All ports
    protocol    = "-1"        # All protocols (-1 means all)
    cidr_blocks = ["0.0.0.0/0"] # To anywhere
    description = "Allow all outbound traffic"
  }

  # Ingress (inbound) rule: Allow SSH access
  # This rule allows SSH connections from your IP address
  # WARNING: In production, restrict this to your specific IP instead of 0.0.0.0/0
  ingress {
    from_port   = 22         # SSH port
    to_port     = 22         # SSH port
    protocol    = "tcp"      # TCP protocol
    cidr_blocks = ["0.0.0.0/0"] # From anywhere (not recommended for production)
    description = "Allow SSH from anywhere"
  }

  # Ingress rule: Allow HTTP access
  # This rule allows HTTP web traffic
  ingress {
    from_port   = 80        # HTTP port
    to_port     = 80        # HTTP port
    protocol    = "tcp"     # TCP protocol
    cidr_blocks = ["0.0.0.0/0"] # From anywhere
    description = "Allow HTTP from anywhere"
  }

  # Ingress rule: Allow HTTPS access
  # This rule allows HTTPS/SSL web traffic
  ingress {
    from_port   = 443       # HTTPS port
    to_port     = 443       # HTTPS port
    protocol    = "tcp"     # TCP protocol
    cidr_blocks = ["0.0.0.0/0"] # From anywhere
    description = "Allow HTTPS from anywhere"
  }

  # Resource tags for identification and organization
  tags = {
    Name = "hello-world-security-group"
  }

  # Lifecycle rule: Always revoke rules before destroying (useful during updates)
  lifecycle {
    create_before_destroy = true
  }
}

# AWS EC2 Instance
# This resource creates a virtual machine in AWS
resource "aws_instance" "hello_world" {
  # Amazon Machine Image (AMI) ID for Ubuntu 20.04 LTS
  # This ID is for us-east-1 region; use different ID for other regions
  # Note: Free tier eligible
  ami = "ami-0c55b159cbfafe1f0"

  # Instance type: t2.micro is free tier eligible
  # Other options: t2.small, t2.medium, t2.large, etc.
  instance_type = var.instance_type

  # Associate with the security group we created above
  vpc_security_group_ids = [aws_security_group.hello_world.id]

  # Enable detailed monitoring (optional, costs money)
  # Set to true for additional CloudWatch metrics
  monitoring = false

  # User data script - runs when instance starts
  # This script runs as root and installs basic web server
  # Note: Using base64encode() to properly encode multiline scripts
  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Update system packages
              apt-get update
              apt-get install -y curl wget

              # Create simple web content
              mkdir -p /var/www/html
              echo "<h1>Hello from Terraform Day 1!</h1>" > /var/www/html/index.html
              echo "<p>Instance ID: $(ec2-metadata --instance-id | cut -d ' ' -f 2)</p>" >> /var/www/html/index.html
              echo "<p>Availability Zone: $(ec2-metadata --availability-zone | cut -d ' ' -f 2)</p>" >> /var/www/html/index.html

              # Install and start web server (optional)
              # apt-get install -y apache2
              # systemctl start apache2
              # systemctl enable apache2
              EOF
  )

  # Root volume configuration
  root_block_device {
    volume_type = "gp2"        # General purpose SSD
    volume_size = 20           # Size in GB (free tier allows up to 30GB)
    delete_on_termination = true  # Delete volume when instance is deleted
  }

  # Enable IMDSv2 for better security
  # This prevents potential security issues with metadata service
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  # Prevent accidental termination
  disable_api_termination = false

  # Resource tags for easy identification
  tags = {
    Name = "hello-world-instance"
    Day  = "Day1"
  }

  # Dependencies - ensure security group exists first
  depends_on = [aws_security_group.hello_world]

  # Add a comment for future reference
  lifecycle {
    ignore_changes = [ami]  # Ignore changes to AMI if it's been manually changed
  }
}

# Local values for commonly used configurations
locals {
  # Common naming prefix for all resources
  name_prefix = "day1"

  # Environment designation
  environment = "learning"

  # Common tags applied to all resources
  common_tags = {
    Project     = "Terraform30Days"
    CreatedDate = "2024"
    ManagedBy   = "Terraform"
  }
}
