# Day 19: Functions and Expressions
# Ngay 19: Ham va Bieu thuc

## Objectives / Muc tieu

- Understand built-in functions
- Use string functions
- Work with collection functions
- Apply numeric functions
- Use date and time functions

## Function Categories / Cac loai Ham

1. String Functions
2. Collection Functions
3. Numeric Functions
4. Encoding Functions
5. Filesystem Functions
6. Date/Time Functions
7. IP Network Functions
8. Type Conversion Functions

## Common String Functions / Ham Chuoi Thuong dung

```hcl
upper("hello")           # HELLO
lower("WORLD")           # world
title("hello world")     # Hello World
substr("hello", 0, 3)    # hel
replace("hello", "l", "L") # heLLo
split(",", "a,b,c")      # ["a", "b", "c"]
join(",", ["a", "b"])    # "a,b"
```

## Collection Functions / Ham Thu tap

```hcl
length([1, 2, 3])                    # 3
concat([1, 2], [3, 4])               # [1, 2, 3, 4]
contains([1, 2, 3], 2)               # true
merge({a=1}, {b=2})                  # {a=1, b=2}
keys({a=1, b=2})                     # ["a", "b"]
values({a=1, b=2})                   # [1, 2]
```

## Numeric Functions / Ham So

```hcl
min(1, 2, 3)        # 1
max(1, 2, 3)        # 3
ceil(4.3)           # 5
floor(4.7)          # 4
abs(-5)             # 5
```

## Key Takeaways / Diem Chinh

- Terraform has many built-in functions
- Functions make configurations dynamic
- No user-defined functions
- Combine functions for complex logic
- Test functions in console

---

End of Day 19 / Ket thuc Ngay 19
