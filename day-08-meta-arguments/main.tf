# Day 8: Meta-arguments - Main Configuration

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
      Day    = "Day8"
    }
  }
}

# Demonstrate count meta-argument
resource "aws_instance" "count_demo" {
  count             = var.create_instances ? var.instance_count : 0
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = {
    Name = "instance-${count.index + 1}"
    Type = "count-demo"
  }
}

# Demonstrate for_each meta-argument
resource "aws_s3_bucket" "for_each_demo" {
  for_each = var.bucket_config

  bucket = "${each.key}-bucket-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = each.key
    Environment = each.value.environment
    Versioning  = each.value.enable_versioning
  }
}

# Enable versioning with for_each
resource "aws_s3_bucket_versioning" "for_each_demo" {
  for_each = aws_s3_bucket.for_each_demo

  bucket = each.value.id

  versioning_configuration {
    status = var.bucket_config[each.key].enable_versioning ? "Enabled" : "Suspended"
  }
}

# Demonstrate depends_on meta-argument
resource "aws_security_group" "dependencies" {
  name        = "day8-sg"
  description = "Demonstrates depends_on"

  depends_on = [aws_instance.count_demo]

  tags = {
    Name = "depends-on-demo"
  }
}

# Demonstrate lifecycle meta-argument
resource "aws_sns_topic" "lifecycle_demo" {
  name = "day8-lifecycle-${data.aws_caller_identity.current.account_id}"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags["Temporary"]]
  }

  tags = {
    Name = "lifecycle-demo"
  }
}

# Demonstrate provider meta-argument with aliases
# (Requires additional provider blocks)
resource "aws_sns_topic" "different_region" {
  # This would use an aliased provider if configured
  name = "day8-different-region"

  tags = {
    Name = "Different region topic"
  }
}

# Demonstrate timeouts meta-argument
resource "aws_security_group" "with_timeouts" {
  name        = "day8-sg-timeouts"
  description = "Demonstrates timeouts"

  timeouts {
    create = "10m"
    delete = "15m"
  }

  tags = {
    Name = "timeouts-demo"
  }
}

# Data sources
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}
