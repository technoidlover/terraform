````markdown
# Day 9: Expressions and Functions

Master Terraform's built-in functions and expression capabilities for dynamic configurations.

## Key Topics

1. String Functions
2. Numeric Functions
3. Collection Functions
4. Type Functions
5. String Interpolation
6. Conditional Expressions

## String Functions

```hcl
# Length
length("hello")  # 5

# Concatenation
concat("hello", " ", "world")  # "hello world"

# Uppercase/Lowercase
upper("hello")   # "HELLO"
lower("HELLO")   # "hello"

# Trim
trim("  hello  ")  # "hello"

# Replace
replace("hello", "l", "L")  # "heLLo"

# Split
split(",", "a,b,c")  # ["a", "b", "c"]

# Join
join("-", ["a", "b", "c"])  # "a-b-c"

# Regex
regex("\\d+", "abc123def")  # "123"
```

## Numeric Functions

```hcl
# Min/Max
min(1, 2, 3)   # 1
max(1, 2, 3)   # 3

# Ceil/Floor
ceil(1.3)      # 2
floor(1.7)     # 1

# Abs
abs(-5)        # 5

# Range
range(5)       # [0, 1, 2, 3, 4]
range(1, 5)    # [1, 2, 3, 4]
```

## Collection Functions

```hcl
# List operations
concat([1, 2], [3, 4])      # [1, 2, 3, 4]
distinct([1, 2, 2, 3])      # [1, 2, 3]
flatten([[1, 2], [3, 4]])   # [1, 2, 3, 4]
reverse([1, 2, 3])          # [3, 2, 1]

# Map operations
keys({a = 1, b = 2})        # ["a", "b"]
values({a = 1, b = 2})      # [1, 2]
merge({a = 1}, {b = 2})     # {a = 1, b = 2}

# Advanced
lookup({a = 1, b = 2}, "a", 0)     # 1
contains(["a", "b"], "a")          # true
index(["a", "b", "c"], "b")        # 1
```

## Conditional Expressions

```hcl
# Ternary operator
var.environment == "production" ? "t2.large" : "t2.micro"

# In variables
variable "instance_type" {
  type = string
  default = var.environment == "production" ? "m5.large" : "t2.micro"
}

# Nested conditions
local.environment == "production" ? (
  local.enable_monitoring ? "t2.xlarge" : "t2.large"
) : "t2.micro"
```

## Type Conversion Functions

```hcl
# String to number
tonumber("123")      # 123

# Number to string
tostring(123)        # "123"

# To list
tolist({"a" = 1})    # ["a"]

# To map
tomap(["a", "b"])    # Error - invalid

# Type checking
type(var.value)      # Returns type as string
```

## Lab: Dynamic Configuration

```hcl
# variables.tf
variable "environment" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "tags" {
  type = map(string)
}

# main.tf
locals {
  # Conditional values
  instance_type = var.environment == "production" ? "t2.large" : "t2.micro"
  instance_count = var.environment == "production" ? 3 : 1

  # String functions
  name_prefix = lower("${var.environment}-web")

  # Merged tags
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

# Using functions in resources
resource "aws_instance" "app" {
  count         = local.instance_count
  instance_type = local.instance_type

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-${count.index + 1}"
    }
  )
}
```

---

Estimated Time: 2-3 hours

````
