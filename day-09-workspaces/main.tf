# Day 9: Workspaces - Main Configuration

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Course    = "Terraform30Days"
      Day       = "Day9"
      Workspace = terraform.workspace
    }
  }
}

# Use workspace information in resource configuration
locals {
  workspace_name = terraform.workspace
  
  # Different configurations per workspace
  workspace_config = {
    default = {
      instance_count   = 1
      instance_type    = "t3.micro"
      enable_backup    = false
      environment_name = "development"
    }
    staging = {
      instance_count   = 2
      instance_type    = "t3.small"
      enable_backup    = true
      environment_name = "staging"
    }
    production = {
      instance_count   = 3
      instance_type    = "t3.medium"
      enable_backup    = true
      environment_name = "production"
    }
  }
  
  current_workspace_config = local.workspace_config[local.workspace_name]
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${local.workspace_name}"
  }
}

# Create subnets
resource "aws_subnet" "main" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "subnet-${local.workspace_name}-${count.index + 1}"
  }
}

# Create security group
resource "aws_security_group" "main" {
  name   = "day9-sg-${local.workspace_name}"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${local.workspace_name}"
  }
}

# Create EC2 instances based on workspace configuration
resource "aws_instance" "main" {
  count           = local.current_workspace_config.instance_count
  ami             = data.aws_ami.ubuntu.id
  instance_type   = local.current_workspace_config.instance_type
  subnet_id       = aws_subnet.main[count.index % length(aws_subnet.main)].id
  security_groups = [aws_security_group.main.id]

  tags = {
    Name        = "instance-${local.workspace_name}-${count.index + 1}"
    Environment = local.current_workspace_config.environment_name
    Workspace   = local.workspace_name
  }
}

# Create EBS volumes only in production workspace
resource "aws_ebs_volume" "backup" {
  count             = local.current_workspace_config.enable_backup ? local.current_workspace_config.instance_count : 0
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  size              = 100

  tags = {
    Name = "backup-${local.workspace_name}-${count.index + 1}"
  }
}

# Data sources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
