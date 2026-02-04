# Day 3: Variables and Outputs

## Learning Objectives

Understanding input variables, output values, and type constraints in Terraform.

## Key Topics

1. Input Variables
2. Variable Types
3. Variable Validation
4. Output Values
5. Sensitive Outputs
6. Type Constraints

## Input Variables

Variables make configurations reusable and flexible.

### Basic Variable Declaration

```hcl
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
```

### Variable Types

```hcl
# String
variable "name" {
  type = string
}

# Number
variable "port" {
  type = number
}

# Boolean
variable "enable_monitoring" {
  type = bool
}

# List
variable "availability_zones" {
  type = list(string)
}

# Map
variable "tags" {
  type = map(string)
}

# Set
variable "unique_items" {
  type = set(string)
}

# Tuple (fixed length, mixed types)
variable "mixed_tuple" {
  type = tuple([string, number, bool])
}

# Object (structured map)
variable "instance_config" {
  type = object({
    name          = string
    instance_type = string
    enabled       = bool
  })
}
```

### Variable Validation

```hcl
variable "instance_type" {
  type = string

  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must start with t2 or t3."
  }
}

variable "port" {
  type = number

  validation {
    condition     = var.port >= 1 && var.port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}
```

## Output Values

Outputs export important values for use after applying the configuration.

### Basic Output

```hcl
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

### Output with Description

```hcl
output "instance_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}
```

### Sensitive Outputs

```hcl
output "database_password" {
  value     = random_password.db.result
  sensitive = true  # Hides output value in logs
}
```

## Lab: Variables and Outputs

### variables.tf

```hcl
# Environment configuration
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be development, staging, or production."
  }
}

# Compute configuration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must be t2 or t3 family."
  }
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

# Network configuration
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Tags
variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "Terraform30Days"
    ManagedBy   = "Terraform"
    CreatedDate = "2024"
  }
}
```

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
  region = "us-east-1"

  default_tags {
    tags = var.common_tags
  }
}

# Create multiple instances based on variable
resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name = "instance-${count.index + 1}"
  }
}
```

### outputs.tf

```hcl
output "instance_ids" {
  description = "IDs of created instances"
  value       = aws_instance.app[*].id
}

output "instance_ips" {
  description = "Public IPs of instances"
  value       = aws_instance.app[*].public_ip
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "total_instances" {
  description = "Total number of instances"
  value       = length(aws_instance.app)
}
```

## Exercises

### Exercise 1: Create Variables

1. Define 3 input variables with different types
2. Add validation to each
3. Create matching outputs

### Exercise 2: Use Dynamic Values

1. Use variables to control resource creation
2. Create multiple resources based on count variable
3. Output all resource IDs

## Best Practices

1. Always add descriptions to variables
2. Specify types explicitly
3. Add validation when possible
4. Use meaningful variable names
5. Provide sensible defaults
6. Mark sensitive outputs
7. Group related variables
8. Keep terraform.tfvars out of version control

---

Estimated Time: 2-3 hours
