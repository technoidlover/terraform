# Day 10: Conditionals and Loops

Master iteration and conditional logic in Terraform configurations.

## Key Topics

1. Count Meta-Argument
2. For-Each Meta-Argument
3. For Expressions
4. Conditional Logic
5. Dynamic Blocks

## Count Meta-Argument

Create multiple similar resources:

```hcl
variable "instance_count" {
  type    = number
  default = 3
}

# Create multiple instances
resource "aws_instance" "app" {
  count         = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "instance-${count.index + 1}"
  }
}

# Reference individual resources
output "instance_ids" {
  value = aws_instance.app[*].id
}

# Reference specific instance
output "first_instance_id" {
  value = aws_instance.app[0].id
}
```

## For-Each Meta-Argument

Iterate over maps or sets:

```hcl
variable "instances" {
  type = map(string)
  default = {
    web = "t2.micro"
    api = "t2.small"
    db  = "t2.medium"
  }
}

# Create instance for each map entry
resource "aws_instance" "app" {
  for_each      = var.instances
  instance_type = each.value

  tags = {
    Name = each.key
  }
}

# Reference all instances
output "instance_ids" {
  value = {
    for name, instance in aws_instance.app : name => instance.id
  }
}

# Reference specific instance
output "web_instance" {
  value = aws_instance.app["web"].id
}
```

## For Expressions

Transform collections:

```hcl
# List comprehension
variable "names" {
  type = list(string)
  default = ["alice", "bob", "charlie"]
}

locals {
  uppercase_names = [for name in var.names : upper(name)]
  # ["ALICE", "BOB", "CHARLIE"]
}

# Map construction
locals {
  name_lengths = {
    for name in var.names : name => length(name)
  }
  # {alice = 5, bob = 3, charlie = 7}
}

# Filtering
locals {
  long_names = [for name in var.names : name if length(name) > 3]
  # ["alice", "charlie"]
}
```

## Dynamic Blocks

Create variable number of blocks:

```hcl
variable "ingress_rules" {
  type = list(object({
    port     = number
    protocol = string
  }))
}

resource "aws_security_group" "app" {
  name = "app-sg"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

## Lab: Complex Iteration

```hcl
# Create multiple environments with different configs
variable "environments" {
  type = map(object({
    instance_type = string
    instance_count = number
  }))

  default = {
    development = {
      instance_type  = "t2.micro"
      instance_count = 1
    }
    production = {
      instance_type  = "t2.large"
      instance_count = 3
    }
  }
}

resource "aws_instance" "app" {
  for_each      = {
    for env, config in var.environments : env => config
  }
  
  instance_type = each.value.instance_type
  ami           = "ami-0c55b159cbfafe1f0"
  count         = each.value.instance_count

  tags = {
    Environment = each.key
    Name        = "${each.key}-instance-${count.index + 1}"
  }
}

output "instances" {
  value = {
    for env, instances in aws_instance.app : env => {
      for idx, instance in instances : idx => instance.id
    }
  }
}
```

## Exercises

1. Create multiple resources with count
2. Create resources with for_each
3. Use dynamic blocks
4. Transform data with for expressions
5. Combine multiple iteration methods

## Best Practices

1. Use count for homogeneous resources
2. Use for_each for heterogeneous resources
3. Use for expressions for data transformation
4. Document complex loops
5. Test with small counts first
6. Avoid deeply nested loops
7. Use meaningful variable names

---

Estimated Time: 3 hours
