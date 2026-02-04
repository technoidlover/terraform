# Terraform Complete Reference

## Core Language Elements

### Comments

```hcl
# Single line comment

/*
Multi-line comment
Useful for longer explanations
*/
```

### Terraform Block

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### Provider Block

```hcl
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
    }
  }
}

# Multiple providers with aliases
provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}
```

### Variable Declaration

```hcl
variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 1
  sensitive   = false

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
```

### Local Values

```hcl
locals {
  # Simple values
  environment = var.environment
  region      = var.aws_region

  # Computed values
  name_prefix = "${var.project}-${local.environment}"

  # Complex structures
  common_tags = {
    Environment = local.environment
    Project     = var.project
    CreatedBy   = "Terraform"
  }

  # Conditionals
  instance_type = local.environment == "prod" ? "t2.large" : "t2.micro"
}
```

### Resource Definition

```hcl
resource "aws_instance" "web" {
  # Required arguments
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  # Optional arguments
  monitoring = true
  key_name   = aws_key_pair.main.key_name

  # Nested blocks
  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  # Meta-arguments
  count = var.create_instances ? 3 : 0
  
  tags = merge(
    local.common_tags,
    {
      Name = "web-${count.index + 1}"
    }
  )

  depends_on = [aws_security_group.web]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami]
    prevent_destroy       = false
  }
}
```

### Data Source

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Usage
resource "aws_instance" "app" {
  ami = data.aws_ami.ubuntu.id
}
```

### Output Values

```hcl
output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id
  sensitive   = false
}

# Sensitive output
output "database_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}

# Complex output
output "instance_info" {
  value = {
    id        = aws_instance.web.id
    public_ip = aws_instance.web.public_ip
    private_ip = aws_instance.web.private_ip
  }
}
```

### Module Definition

```hcl
module "vpc" {
  source = "./modules/vpc"
  # or: "terraform-aws-modules/vpc/aws" (from registry)

  name = var.vpc_name
  cidr = var.vpc_cidr

  providers = {
    aws = aws.primary
  }

  tags = local.common_tags
}

# Access module outputs
resource "aws_instance" "app" {
  subnet_id = module.vpc.private_subnet_ids[0]
}
```

## Type System

### Primitive Types

```hcl
variable "string_var" {
  type = string
  default = "hello"
}

variable "number_var" {
  type = number
  default = 42
}

variable "bool_var" {
  type = bool
  default = true
}
```

### Collection Types

```hcl
# List
variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

# Map
variable "tags" {
  type = map(string)
  default = {
    Environment = "production"
    Owner       = "platform"
  }
}

# Set (unique items)
variable "unique_ids" {
  type = set(string)
}

# Tuple (fixed length, mixed types)
variable "tuple_example" {
  type = tuple([string, number, bool])
}

# List of objects
variable "instances" {
  type = list(object({
    name          = string
    instance_type = string
  }))
}
```

## Control Flow

### Conditionals

```hcl
# Ternary operator
var.environment == "production" ? "t2.large" : "t2.micro"

# In variable
locals {
  instance_type = var.environment == "prod" ? "t2.large" : "t2.micro"
}

# Multiple conditions
local.enable_monitoring && local.environment == "prod" ? "true" : "false"
```

### Count Meta-Argument

```hcl
# Create multiple instances
resource "aws_instance" "app" {
  count         = var.instance_count
  instance_type = "t2.micro"

  tags = {
    Name = "instance-${count.index + 1}"
  }
}

# Reference
output "instance_ids" {
  value = aws_instance.app[*].id
}

output "first_instance" {
  value = aws_instance.app[0].id
}
```

### For-Each Meta-Argument

```hcl
# Create instances for each map entry
resource "aws_instance" "app" {
  for_each      = var.instances
  instance_type = each.value.type

  tags = {
    Name = each.key
  }
}

# Reference
output "instance_map" {
  value = {
    for name, instance in aws_instance.app : name => instance.id
  }
}
```

### For Expressions

```hcl
# List transformation
[for instance in aws_instance.app : instance.id]

# List filtering
[for item in var.items : item if item.enabled]

# Map transformation
{
  for item in var.items : item.name => item.value
}

# Key-value iteration
{
  for key, value in var.map : key => "${value}!"
}
```

### Dynamic Blocks

```hcl
resource "aws_security_group" "app" {
  name = "app-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      security_groups = ingress.value.security_groups
    }
  }
}
```

## Built-in Functions

### String Functions

```hcl
upper("hello")                      # HELLO
lower("HELLO")                      # hello
title("hello world")                # Hello World
trim("  hello  ")                   # hello
trimprefix("hello world", "hello")  # " world"
trimsuffix("hello world", "world")  # "hello "
replace("hello", "l", "L")          # heLLo
concat("a", "b", "c")               # abc
join(",", ["a", "b"])               # a,b
split(",", "a,b,c")                 # ["a", "b", "c"]
length("hello")                     # 5
substr("hello", 0, 3)               # hel
format("%s-%d", "test", 123)        # test-123
regex("\\d+", "abc123")             # 123
```

### List Functions

```hcl
concat([1, 2], [3, 4])              # [1, 2, 3, 4]
contains([1, 2, 3], 2)              # true
index([1, 2, 3], 2)                 # 1
flatten([[1, 2], [3, 4]])           # [1, 2, 3, 4]
reverse([1, 2, 3])                  # [3, 2, 1]
distinct([1, 2, 2, 3])              # [1, 2, 3]
sort([3, 1, 2])                     # [1, 2, 3]
length([1, 2, 3])                   # 3
```

### Map Functions

```hcl
keys({a = 1, b = 2})                # ["a", "b"]
values({a = 1, b = 2})              # [1, 2]
lookup({a = 1}, "a", 0)             # 1
merge({a = 1}, {b = 2})             # {a = 1, b = 2}
length({a = 1, b = 2})              # 2
```

### Numeric Functions

```hcl
min(1, 2, 3)                        # 1
max(1, 2, 3)                        # 3
sum([1, 2, 3])                      # 6
ceil(1.2)                           # 2
floor(1.8)                          # 1
round(1.5)                          # 2
abs(-5)                             # 5
```

### Type Functions

```hcl
type(var.value)                     # "string", "number", etc.
length(list_or_map)                 # Number of elements
tonumber("123")                     # 123
tostring(123)                       # "123"
tolist(var.value)                   # Convert to list
tomap(var.value)                    # Convert to map
base64encode("hello")               # SGVsbG8=
base64decode("SGVsbG8=")             # hello
jsonencode({a = 1})                 # {"a":1}
jsondecode("{\"a\":1}")             # {a = 1}
```

## Accessing Resource Attributes

```hcl
# Reference resource attribute
aws_instance.web.id
aws_instance.web.public_ip
aws_instance.web.private_ip
aws_instance.web.availability_zone

# Reference module output
module.vpc.vpc_id
module.vpc.subnet_ids[0]

# Reference data source
data.aws_ami.ubuntu.id
data.aws_availability_zones.available.names[0]

# Conditional attribute access
try(aws_instance.web.public_ip, "")
```

## State Management

### Terraform State Commands

```bash
# List resources
terraform state list

# Show resource details
terraform state show aws_instance.web

# Move resource
terraform state mv aws_instance.web aws_instance.app

# Remove resource from state
terraform state rm aws_instance.web

# Pull remote state
terraform state pull > state.json

# Push state
terraform state push state.json

# Replace resource
terraform state replace-provider hashicorp/aws hashicorp/aws
```

### Backend Configuration

```hcl
# Local backend (default)
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# S3 backend
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Terraform Cloud backend
terraform {
  cloud {
    organization = "my-org"
    
    workspaces {
      name = "production"
    }
  }
}
```

## CLI Commands and Flags

### Common Flags

```bash
# Variable assignment
-var 'key=value'
-var-file=prod.tfvars

# Target specific resources
-target=aws_instance.web
-target=module.vpc

# Continue on error
-auto-approve
-parallelism=1

# Debugging
-input=false
-lock=false
-log=trace

# Output format
-json
-raw
```

### Workflow Commands

```bash
# Show plan in detail
terraform show plan.tfplan

# Refresh state without modifying resources
terraform refresh

# Console for interactive evaluation
terraform console

# Graph dependency visualization
terraform graph

# Configuration import
terraform import aws_instance.example i-1234567890abcdef0
```

## Security Considerations

### Protecting Secrets

```hcl
# Mark as sensitive
variable "db_password" {
  type      = string
  sensitive = true
}

# Sensitive outputs don't display value
output "db_password" {
  value     = aws_db_instance.main.password
  sensitive = true
}

# Use Secrets Manager or similar
resource "aws_secretsmanager_secret" "db_password" {
  name = "db-password"
}

# Reference secret
resource "aws_db_instance" "main" {
  password = jsondecode(
    data.aws_secretsmanager_secret_version.db_password.secret_string
  ).password
}
```

### Permission Boundaries

```bash
# Use specific IAM permissions, not wildcard
Action = [
  "s3:GetObject",
  "s3:PutObject"
]
Resource = "${aws_s3_bucket.data.arn}/*"

# Not:
Action = "*"
Resource = "*"
```

## Error Handling

### Try Function

```hcl
# Use try to handle errors gracefully
locals {
  public_ip = try(aws_instance.web.public_ip, "")
}

# Try multiple options
value = try(var.option1, var.option2, "default")
```

### Validation

```hcl
variable "port" {
  type = number

  validation {
    condition     = var.port >= 1 && var.port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}

# Validation with multiple checks
validation {
  condition     = can(regex("^[a-z0-9-]+$", var.name))
  error_message = "Name must contain only lowercase letters, numbers, and hyphens."
}
```

## Performance Optimization

```bash
# Limit parallelism for stability
terraform apply -parallelism=2

# Plan to file for faster apply
terraform plan -out=tfplan
terraform apply tfplan

# Refresh before plan to avoid outdated state
terraform refresh
terraform plan

# Target for testing
terraform apply -target=aws_instance.web
```

## Useful Patterns

### Optional Attributes

```hcl
variable "enable_monitoring" {
  type    = bool
  default = false
}

resource "aws_instance" "app" {
  monitoring = var.enable_monitoring

  # Optional block
  dynamic "ebs_block_device" {
    for_each = var.enable_monitoring ? [1] : []
    content {
      device_name = "/dev/sdf"
      volume_size = 100
    }
  }
}
```

### Environment-Specific Configuration

```hcl
locals {
  config = {
    dev = {
      instance_type = "t2.micro"
      instance_count = 1
    }
    prod = {
      instance_type = "t2.large"
      instance_count = 3
    }
  }

  current_config = local.config[var.environment]
}

resource "aws_instance" "app" {
  instance_type = local.current_config.instance_type
  count         = local.current_config.instance_count
}
```

### Tagging Pattern

```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project
    CreatedBy   = "Terraform"
    CreatedDate = timestamp()
  }
}

resource "aws_instance" "app" {
  tags = merge(
    local.common_tags,
    {
      Name = var.instance_name
    }
  )
}
```

---

Last Updated: February 2026
