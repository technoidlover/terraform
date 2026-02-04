# Day 15: AWS IAM

Manage users, roles, policies, and permissions with IAM.

## Key Topics

1. IAM Users
2. IAM Roles
3. IAM Policies
4. Instance Profiles
5. Policy Attachment

## IAM User

```hcl
resource "aws_iam_user" "developer" {
  name = "john-developer"

  tags = {
    Department = "Engineering"
  }
}

# Access key
resource "aws_iam_access_key" "developer" {
  user = aws_iam_user.developer.name
}

# Attach policy
resource "aws_iam_user_policy_attachment" "developer" {
  user       = aws_iam_user.developer.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

output "access_key" {
  value     = aws_iam_access_key.developer.id
  sensitive = true
}
```

## IAM Role

```hcl
# Trust policy for EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Inline policy
resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

# Instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Use in EC2
resource "aws_instance" "app" {
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  # ... other configuration
}
```

## Custom Policies

```hcl
# Custom policy document
data "aws_iam_policy_document" "s3_access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.data.arn}/*"
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"
      values   = ["10.0.0.0/8"]
    }
  }
}

resource "aws_iam_role_policy" "s3_policy" {
  name   = "s3-policy"
  role   = aws_iam_role.app_role.id
  policy = data.aws_iam_policy_document.s3_access.json
}
```

## Lab: Complete IAM Setup

See main.tf for production-ready IAM configuration with multiple roles and policies.

---

Estimated Time: 3 hours
