# Day 4: Data Sources and Locals

## Learning Objectives

Understand how to query existing resources and define local values in Terraform.

## Key Topics

1. Data Sources
2. Local Values
3. Dynamic Data Retrieval
4. Filtering Data
5. Combining Data Sources

## Data Sources

Data sources allow you to query and reference existing infrastructure.

### Common AWS Data Sources

```hcl
# Query latest AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Query availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Query VPC
data "aws_vpc" "default" {
  default = true
}

# Query subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Query security groups
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}
```

### Using Data Sources

```hcl
resource "aws_instance" "app" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # Use data source to select AZ
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "app-server"
  }
}
```

## Local Values

Locals are intermediate values that simplify configuration.

### Basic Locals

```hcl
locals {
  # Simple values
  environment = "production"
  region      = "us-east-1"

  # Computed values
  name_prefix = "${var.project}-${local.environment}"

  # Complex structures
  common_tags = {
    Environment = local.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  }

  # Conditional values
  instance_type = var.environment == "production" ? "t2.large" : "t2.micro"
}
```

### Using Locals

```hcl
resource "aws_instance" "app" {
  instance_type = local.instance_type

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance"
    }
  )
}
```

## Lab: Data Sources and Locals

### main.tf

```hcl
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
}

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Local values for consistent naming and tagging
locals {
  environment   = var.environment
  name_prefix   = "${var.project}-${local.environment}"
  instance_type = var.environment == "production" ? "t2.large" : "t2.micro"

  common_tags = {
    Project     = var.project
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

# Create instance using data sources
resource "aws_instance" "app" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = local.instance_type
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-instance"
    }
  )
}
```

### variables.tf

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Must be development, staging, or production."
  }
}
```

### outputs.tf

```hcl
output "ami_id" {
  description = "AMI ID used"
  value       = data.aws_ami.ubuntu.id
}

output "ami_name" {
  description = "AMI name"
  value       = data.aws_ami.ubuntu.name
}

output "available_azs" {
  description = "Available AZs"
  value       = data.aws_availability_zones.available.names
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.app.id
}
```

## Exercises

### Exercise 1: Query Data Sources

1. Create configuration that queries available AZs
2. Output the AZ names
3. Use first AZ for resource

### Exercise 2: Use Locals

1. Define multiple local values
2. Use them in resource definitions
3. Verify they are evaluated correctly

## Best Practices

1. Use data sources to avoid hardcoding values
2. Use locals to avoid repetition
3. Document complex local calculations
4. Group related locals together
5. Use meaningful names for locals
6. Validate data source results

---

Estimated Time: 2 hours
