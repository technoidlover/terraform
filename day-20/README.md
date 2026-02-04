# Day 20: Conditional Expressions and Loops
# Ngay 20: Bieu thuc Dieu kien va Vong lap

## Objectives / Muc tieu

- Use conditional expressions
- Implement for loops
- Work with for_each
- Use count for iteration
- Apply dynamic blocks

## Conditional Expressions / Bieu thuc Dieu kien

```hcl
condition ? true_value : false_value

# Example
environment = var.is_prod ? "production" : "development"
```

## For Expressions / Bieu thuc For

```hcl
# List comprehension
[for item in list : upper(item)]

# Map comprehension
{for k, v in map : k => upper(v)}

# Filtering
[for item in list : item if condition]
```

## Count Meta-Argument / Meta-Argument Count

```hcl
resource "aws_instance" "server" {
  count = 3
  
  tags = {
    Name = "server-${count.index}"
  }
}
```

## For_Each Meta-Argument / Meta-Argument For_Each

```hcl
resource "aws_instance" "server" {
  for_each = toset(["web", "api", "db"])
  
  tags = {
    Name = each.key
  }
}
```

## Dynamic Blocks / Khoi Dynamic

```hcl
dynamic "ingress" {
  for_each = var.ports
  content {
    from_port = ingress.value
    to_port   = ingress.value
  }
}
```

## Key Takeaways / Diem Chinh

- Conditionals use ternary operator
- For expressions transform collections
- Count creates indexed instances
- For_each creates named instances
- Dynamic blocks reduce repetition

---

End of Day 20 / Ket thuc Ngay 20
