# Day 8: Input Variables
# Ngay 8: Bien dau vao

## Objectives / Muc tieu

- Understand input variables
- Learn variable types and validation
- Use variables in configurations
- Set variable values different ways
- Implement variable best practices

## Variable Declaration / Khai bao Bien

```hcl
variable "variable_name" {
  description = "Description of the variable"
  type        = string
  default     = "default_value"
  sensitive   = false
  validation {
    condition     = length(var.variable_name) > 0
    error_message = "Variable cannot be empty"
  }
}
```

## Variable Types / Kieu Bien

- `string`: Text values
- `number`: Numeric values
- `bool`: true or false
- `list(type)`: Ordered collection
- `map(type)`: Key-value pairs
- `set(type)`: Unique values
- `object({...})`: Complex structure
- `tuple([...])`: Fixed-length collection

## Setting Variable Values / Gan Gia tri Bien

1. Command line: `-var="name=value"`
2. File: `terraform.tfvars`
3. Environment: `TF_VAR_name`
4. Interactive prompt
5. Default values

## Variable Validation / Xac thuc Bien

```hcl
variable "port" {
  type    = number
  default = 8080
  
  validation {
    condition     = var.port > 0 && var.port < 65536
    error_message = "Port must be between 1 and 65535"
  }
}
```

## Key Takeaways / Diem Chinh

- Variables make configurations reusable
- Always provide descriptions
- Use appropriate types
- Validate input when possible
- Keep sensitive data secure

---

End of Day 8 / Ket thuc Ngay 8
