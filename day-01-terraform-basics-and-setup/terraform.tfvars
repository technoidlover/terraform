# Day 1: Terraform Variables - terraform.tfvars
# This file provides concrete values for the variables declared in variables.tf
# Format: variable_name = value

# AWS Region - change this to your preferred region
# Valid values: us-east-1, us-west-2, eu-west-1, ap-southeast-1, etc.
aws_region = "us-east-1"

# Instance Type - change this to test different instance sizes
# Free tier options: t2.micro (always free), t2.small (free first year)
# Note: Larger instances may incur charges
instance_type = "t2.micro"

# Cost center code for billing purposes
tag_cost_center = "learning"

# Features to enable
# Options: monitoring, backup, logging
enabled_features = ["monitoring"]

# Custom tags
instance_tags = {
  Owner      = "Learning"
  Department = "Engineering"
  Course     = "Terraform30Days"
}
