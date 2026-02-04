# Day 15: AWS IAM - Main Configuration

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
      Course = "Terraform30Days"
      Day    = "Day15"
    }
  }
}

# IAM Users
resource "aws_iam_user" "developers" {
  for_each = toset(var.developer_usernames)

  name = each.value

  tags = {
    Team = "Development"
  }
}

# IAM Group
resource "aws_iam_group" "developers" {
  name = "developers"
}

# Add users to group
resource "aws_iam_user_group_membership" "developers" {
  for_each = aws_iam_user.developers

  user       = each.value.name
  groups     = [aws_iam_group.developers.name]
}

# IAM Role for EC2
resource "aws_iam_role" "ec2_role" {
  name = "day15-ec2-role"

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

  tags = {
    Purpose = "EC2 instance role"
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "day15-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Purpose = "Lambda execution role"
  }
}

# Custom IAM Policy for developers
resource "aws_iam_policy" "developer_policy" {
  name = "day15-developer-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ReadOnlyEC2"
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*"
        ]
        Resource = "*"
      },
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      },
      {
        Sid    = "CloudWatchLogs"
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })

  tags = {
    Purpose = "Developer access policy"
  }
}

# Attach policy to group
resource "aws_iam_group_policy_attachment" "developer_policy" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_policy.arn
}

# Custom IAM Policy for EC2
resource "aws_iam_policy" "ec2_policy" {
  name = "day15-ec2-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "SSMAccess"
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:*:*:parameter/app/*"
      },
      {
        Sid    = "S3ReadWrite"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::day15-*"
      },
      {
        Sid    = "CloudWatchMetrics"
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Purpose = "EC2 instance permissions"
  }
}

# Attach policy to EC2 role
resource "aws_iam_role_policy_attachment" "ec2_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Lambda basic execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Custom Lambda execution policy
resource "aws_iam_policy" "lambda_policy" {
  name = "day15-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PutItem"
        ]
        Resource = "arn:aws:dynamodb:*:*:table/day15-*"
      }
    ]
  })

  tags = {
    Purpose = "Lambda permissions"
  }
}

# Attach Lambda policy
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2" {
  name = "day15-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Access Keys for users (for programmatic access)
resource "aws_iam_access_key" "developers" {
  for_each = var.create_access_keys ? aws_iam_user.developers : {}

  user = each.value.name

  lifecycle {
    create_before_destroy = true
  }
}

# Password policy
resource "aws_iam_account_password_policy" "main" {
  count = var.enforce_password_policy ? 1 : 0

  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
}
