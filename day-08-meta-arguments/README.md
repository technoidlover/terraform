````markdown
# Day 8: Modules Advanced

Master advanced module patterns, composition, and best practices.

## Key Topics

1. Complex Module Structures
2. Module Composition
3. Module Testing
4. Documentation
5. Module Publishing

## Complex Module Variables

```hcl
# Complex object types
variable "instance_config" {
  type = object({
    name          = string
    instance_type = string
    tags = object({
      Environment = string
      Owner       = string
    })
  })
}

# List of objects
variable "instances" {
  type = list(object({
    name          = string
    instance_type = string
  }))
}

# Maps with nested structures
variable "configurations" {
  type = map(object({
    enabled = bool
    settings = map(string)
  }))
}
```

## Module Composition

Creating complex infrastructure from simple modules:

```hcl
# main.tf - Compose multiple modules
module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  region     = var.region
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.id
}

module "instances" {
  source = "./modules/ec2"

  vpc_id              = module.vpc.id
  security_group_ids  = [module.security_groups.web_id]
  availability_zones  = module.vpc.availability_zones
}

module "load_balancer" {
  source = "./modules/alb"

  vpc_id            = module.vpc.id
  instance_ids      = module.instances.ids
  subnets           = module.vpc.public_subnets
}
```

## Module Testing

```bash
# Validate module
terraform validate

# Format check
terraform fmt -check

# Plan with variables
terraform plan -var-file=test.tfvars

# Initialize for module update
terraform init -upgrade
```

## Module Documentation

Create README.md in module:

```markdown
# VPC Module

Creates a VPC with public and private subnets.

## Usage

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  region     = "us-east-1"
}
```

---

Estimated Time: 3 hours

````
