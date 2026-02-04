# Day 7: Modules Introduction

Modules are containers for reusable Terraform configurations. Learn the basics of module structure and usage.

## Key Topics

1. Module Structure
2. Creating Modules
3. Module Variables
4. Module Outputs
5. Using Modules
6. Module Registry

## Module Directory Structure

```
my-module/
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
└── examples/
    └── basic/
        ├── main.tf
        └── terraform.tfvars
```

## Creating a Module

### Module: main.tf

```hcl
resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.ingress_port
    to_port     = var.ingress_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
```

### Module: variables.tf

```hcl
variable "name" {
  description = "Security group name"
  type        = string
}

variable "description" {
  description = "Security group description"
  type        = string
  default     = "Security group"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "ingress_port" {
  description = "Ingress port"
  type        = number
}

variable "allowed_cidr_blocks" {
  description = "Allowed CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}
```

### Module: outputs.tf

```hcl
output "id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}

output "arn" {
  description = "Security group ARN"
  value       = aws_security_group.this.arn
}
```

## Using a Module

```hcl
module "web_sg" {
  source = "./modules/security-group"

  name               = "web-sg"
  description        = "Web server security group"
  vpc_id             = aws_vpc.main.id
  ingress_port       = 80
  allowed_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "production"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.web_sg.id]
}
```

## Registry Modules

Using modules from Terraform Registry:

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Environment = "production"
  }
}
```

## Lab: Create and Use a Module

Create a reusable EC2 module:

```hcl
# modules/ec2-instance/main.tf
resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  monitoring             = var.monitoring

  root_block_device {
    volume_size = var.volume_size
  }

  user_data = base64encode(var.user_data)

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# modules/ec2-instance/variables.tf
variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = null
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "monitoring" {
  type    = bool
  default = false
}

variable "user_data" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

# modules/ec2-instance/outputs.tf
output "id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
```

## Exercises

1. Create a security group module
2. Create an EC2 instance module
3. Use modules in main configuration
4. Test module reusability

## Best Practices

1. Create small, focused modules
2. Write clear documentation
3. Use meaningful variable names
4. Provide sensible defaults
5. Version modules appropriately
6. Test modules thoroughly
7. Make modules generic and reusable

---

Estimated Time: 3 hours
