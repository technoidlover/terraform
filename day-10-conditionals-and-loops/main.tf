# Day 10: Conditionals and Loops - Main Configuration

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
      Course = "Terraform30Days"
      Day    = "Day10"
    }
  }
}

# Conditional: Create resources only if enabled
resource "aws_vpc" "main" {
  count              = var.create_vpc ? 1 : 0
  cidr_block         = var.vpc_cidr
  enable_dns_support = true

  tags = {
    Name = "day10-vpc"
  }
}

# Loop: Create multiple subnets with for_each
resource "aws_subnet" "main" {
  for_each = var.subnets

  vpc_id            = aws_vpc.main[0].id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key
  }
}

# Conditional with inline if/else
resource "aws_internet_gateway" "main" {
  count  = var.create_vpc && var.enable_igw ? 1 : 0
  vpc_id = aws_vpc.main[0].id

  tags = {
    Name = "day10-igw"
  }
}

# Loop: Create security group rules dynamically
resource "aws_security_group" "main" {
  count       = var.create_vpc ? 1 : 0
  name        = "day10-sg"
  description = "Security group with dynamic rules"
  vpc_id      = aws_vpc.main[0].id

  tags = {
    Name = "day10-sg"
  }
}

# Dynamic ingress rules using for_each
resource "aws_vpc_security_group_ingress_rule" "main" {
  for_each = var.create_vpc ? var.security_group_rules : {}

  security_group_id = aws_security_group.main[0].id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_ipv4

  tags = {
    Name = each.key
  }
}

# Egress rule with conditional
resource "aws_vpc_security_group_egress_rule" "main" {
  count = var.create_vpc && var.restrict_egress ? 1 : 0

  security_group_id = aws_security_group.main[0].id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "allow-https"
  }
}

# Create EC2 instances with conditional and loop
resource "aws_instance" "main" {
  for_each = var.create_instances ? var.instances : {}

  ami           = data.aws_ami.ubuntu.id
  instance_type = each.value.instance_type
  subnet_id     = aws_subnet.main[each.value.subnet_key].id

  tags = {
    Name = each.key
    Role = each.value.role
  }
}

# Conditional: Create RDS only in production
resource "aws_db_instance" "main" {
  count                  = var.environment == "production" ? 1 : 0
  identifier             = "day10-db-${lower(var.project_name)}"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = !var.environment == "production"

  tags = {
    Name = "day10-db"
  }
}

# Local variable using conditional logic
locals {
  # Complex conditional using ternary operators
  network_config = var.create_vpc ? {
    vpc_id    = aws_vpc.main[0].id
    subnet_ids = [for k, v in aws_subnet.main : v.id]
    igw_id    = try(aws_internet_gateway.main[0].id, null)
    } : {
    vpc_id    = null
    subnet_ids = []
    igw_id    = null
  }

  # Loop through instances and create a map
  instance_map = {
    for name, instance in aws_instance.main :
    name => instance.id
  }

  # Count instances per role
  role_counts = var.create_instances ? {
    for role in distinct([for i in var.instances : i.role]) :
    role => length([for i in var.instances : i if i.role == role])
  } : {}
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
