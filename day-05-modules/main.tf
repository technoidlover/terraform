# Day 5: Modules and Code Reusability - Main Configuration

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
      Course      = "Terraform30Days"
      Day         = "Day5"
      Environment = var.environment
    }
  }
}

# VPC Module - Demonstrating module reusability
module "vpc_primary" {
  source = "./modules/vpc"

  project_name = var.project_name
  vpc_cidr     = var.vpc_primary_cidr
  subnet_cidrs = var.subnet_cidrs_primary
  environment  = var.environment

  tags = {
    Name   = "Primary VPC"
    Region = var.aws_region
  }
}

module "vpc_secondary" {
  source = "./modules/vpc"

  project_name = "${var.project_name}-secondary"
  vpc_cidr     = var.vpc_secondary_cidr
  subnet_cidrs = var.subnet_cidrs_secondary
  environment  = var.environment

  tags = {
    Name   = "Secondary VPC"
    Region = var.aws_region
  }
}

# Security Group Module
module "security_group_web" {
  source = "./modules/security_group"

  name        = "${var.project_name}-web-sg"
  description = "Security group for web servers"
  vpc_id      = module.vpc_primary.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [var.allowed_cidr]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [var.allowed_cidr]
    }
  ]

  tags = {
    Purpose = "Web Servers"
  }
}

module "security_group_app" {
  source = "./modules/security_group"

  name        = "${var.project_name}-app-sg"
  description = "Security group for application servers"
  vpc_id      = module.vpc_primary.vpc_id

  ingress_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    }
  ]

  tags = {
    Purpose = "Application Servers"
  }
}

# EC2 Module
module "web_servers" {
  source = "./modules/ec2"

  count           = var.enable_web_servers ? 1 : 0
  instance_count  = var.web_server_count
  instance_type   = var.instance_type
  subnet_ids      = module.vpc_primary.subnet_ids
  security_groups = [module.security_group_web.security_group_id]
  project_name    = var.project_name
  role            = "web-server"

  tags = {
    Tier = "Web"
  }

  depends_on = [module.vpc_primary]
}

# Output module information
output "module_info" {
  description = "Information about deployed modules"
  value = {
    primary_vpc_id     = module.vpc_primary.vpc_id
    secondary_vpc_id   = module.vpc_secondary.vpc_id
    web_sg_id          = module.security_group_web.security_group_id
    app_sg_id          = module.security_group_app.security_group_id
    web_server_ids     = try(module.web_servers[0].instance_ids, [])
  }
}
