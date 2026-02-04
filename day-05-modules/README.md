````markdown
# Day 5: Resource Creation

## Learning Objectives

Master the fundamentals of creating and managing resources in Terraform.

## Key Topics

1. Resource Syntax
2. Resource Arguments
3. Resource Attributes
4. Resource Dependencies
5. Resource References
6. Lifecycle Rules

## Resource Syntax

```hcl
resource "resource_type" "resource_name" {
  # Arguments/configuration
  argument = value
}
```

### Complete Example

```hcl
resource "aws_instance" "web" {
  # Required arguments
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  # Optional arguments
  key_name             = "my-key"
  monitoring           = true
  iam_instance_profile = aws_iam_instance_profile.app.name

  # Nested blocks
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  }

  # Tags (most resources support tags)
  tags = {
    Name = "web-server"
  }

  # Lifecycle configuration
  lifecycle {
    prevent_destroy = false
    ignore_changes  = [ami]
  }

  # Dependencies
  depends_on = [aws_security_group.web]
}
```

## Resource References

Accessing resource attributes:

```hcl
# Reference resource attribute
aws_instance.web.id            # Instance ID
aws_instance.web.public_ip     # Public IP
aws_instance.web.private_ip    # Private IP

# Use in other resources
resource "aws_security_group" "app" {
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
}

# Reference in outputs
output "instance_ip" {
  value = aws_instance.web.public_ip
}
```

## Resource Dependencies

### Implicit Dependencies

```hcl
# Terraform automatically detects when resources reference each other
resource "aws_security_group" "web" {
  name = "web-sg"
  # ... configuration ...
}

resource "aws_instance" "web" {
  # Implicit dependency - Terraform knows to create SG first
  vpc_security_group_ids = [aws_security_group.web.id]
}
```

### Explicit Dependencies

```hcl
resource "aws_instance" "app" {
  # ... configuration ...

  # Explicit dependency when implicit one doesn't exist
  depends_on = [
    aws_iam_instance_profile.app,
    aws_security_group.app
  ]
}
```

## Lifecycle Configuration

```hcl
resource "aws_instance" "app" {
  # ... configuration ...

  lifecycle {
    # Prevent accidental destruction
    prevent_destroy = true

    # Create new before destroying old (for updates)
    create_before_destroy = true

    # Ignore changes to these attributes
    ignore_changes = [ami, security_groups]

    # Custom preconditions and postconditions
    precondition {
      condition     = var.instance_type != ""
      error_message = "Instance type must be specified."
    }
  }
}
```

## Lab: Complete Resource Configuration

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

  default_tags {
    tags = {
      Project   = "Day5"
      ManagedBy = "Terraform"
    }
  }
}

# Security group for web server
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web server"

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

# Create EC2 instance
resource "aws_instance" "web" {
  ami               = "ami-0c55b159cbfafe1f0"
  instance_type     = var.instance_type
  availability_zone = var.availability_zone

  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true

    tags = {
      Name = "root-volume"
    }
  }

  user_data = base64encode(var.user_data_script)

  monitoring = true

  tags = {
    Name = "web-server"
  }

  depends_on = [aws_security_group.web]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [ami]
  }
}

# Create Elastic IP for static addressing
resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = {
    Name = "web-eip"
  }

  depends_on = [aws_instance.web]
}
```

### variables.tf

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "user_data_script" {
  description = "User data script"
  type        = string
  default     = "#!/bin/bash\necho 'Hello from Terraform'"
}
```

### outputs.tf

```hcl
output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Instance public IP"
  value       = aws_instance.web.public_ip
}

output "elastic_ip" {
  description = "Elastic IP address"
  value       = aws_eip.web.public_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.web.id
}
```

## Exercises

### Exercise 1: Create Multiple Resources

1. Create VPC
2. Create subnet in VPC
3. Create security group in VPC
4. Create instance in subnet

### Exercise 2: Resource Dependencies

1. Create resource that depends on another
2. Verify dependency order in plan
3. Use both implicit and explicit dependencies

### Exercise 3: Update Resources

1. Change resource configuration
2. Review plan to see what changes
3. Apply changes

## Best Practices

1. Use meaningful resource names
2. Group related resources
3. Always specify required arguments
4. Add tags for organization
5. Document complex configurations
6. Use locals for repeated values
7. Validate before applying
8. Review plan before applying

---

Estimated Time: 2-3 hours

````
