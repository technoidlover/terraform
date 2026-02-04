# Day 29: Real-World Scenarios

Apply Terraform to solve real-world infrastructure challenges.

## Scenarios Covered

1. Multi-Region Deployment
2. Disaster Recovery
3. Cost Optimization
4. Blue-Green Deployment
5. Zero-Downtime Updates

## Scenario 1: Multi-Region Deployment

Deploy same infrastructure across multiple regions for high availability.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "primary"
  region = "us-east-1"
}

provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}

# Primary region resources
module "vpc_primary" {
  source = "./modules/vpc"
  providers = {
    aws = aws.primary
  }

  cidr_block = "10.0.0.0/16"
  region     = "us-east-1"
}

# Secondary region resources
module "vpc_secondary" {
  source = "./modules/vpc"
  providers = {
    aws = aws.secondary
  }

  cidr_block = "10.1.0.0/16"
  region     = "us-west-2"
}

# Route53 for failover
resource "aws_route53_zone" "main" {
  provider = aws.primary
  name     = "example.com"
}

resource "aws_route53_record" "primary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.example.com"
  type    = "A"

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier = "primary"
  alias {
    name                   = "primary-elb.example.com"
    zone_id                = "Z35SXDOTRQ7X7K"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.example.com"
  type    = "A"

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier = "secondary"
  alias {
    name                   = "secondary-elb.example.com"
    zone_id                = "Z1H1FL5HABSF5"
    evaluate_target_health = true
  }
}
```

## Scenario 2: Blue-Green Deployment

Implement zero-downtime deployments.

```hcl
# Blue environment
resource "aws_launch_template" "blue" {
  name_prefix = "blue-"
  image_id    = var.ami_id
  instance_type = var.instance_type

  version_description = "Blue deployment"
}

# Green environment
resource "aws_launch_template" "green" {
  name_prefix = "green-"
  image_id    = var.ami_id_new
  instance_type = var.instance_type

  version_description = "Green deployment"
}

# Auto Scaling Group with active environment toggle
resource "aws_autoscaling_group" "app" {
  name                = "asg-app"
  vpc_zone_identifier = aws_subnet.private[*].id
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size

  # Switch between blue and green
  launch_template {
    id      = var.use_green ? aws_launch_template.green.id : aws_launch_template.blue.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "app-server"
    propagate_at_launch = true
  }
}

# Variable to control blue/green switch
variable "use_green" {
  description = "Switch to green deployment"
  type        = bool
  default     = false
}
```

## Scenario 3: Cost Optimization

Implement cost-saving measures.

```hcl
# Use spot instances for non-critical workloads
resource "aws_launch_template" "cost_optimized" {
  instance_type = var.instance_type

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "cost-optimized"
    }
  }
}

# Schedule instances to stop during off-hours
resource "aws_autoscaling_schedule" "scale_down" {
  scheduled_action_name  = "scale-down-night"
  min_size               = 1
  max_size               = 5
  desired_capacity       = 1
  recurrence             = "0 20 * * *"  # 8 PM daily
  autoscaling_group_name = aws_autoscaling_group.app.name
}

resource "aws_autoscaling_schedule" "scale_up" {
  scheduled_action_name  = "scale-up-morning"
  min_size               = 3
  max_size               = 10
  desired_capacity       = 3
  recurrence             = "0 6 * * *"  # 6 AM daily
  autoscaling_group_name = aws_autoscaling_group.app.name
}

# Use Reserved Instances for baseline
resource "aws_ec2_capacity_reservation" "baseline" {
  instance_type       = "t2.large"
  instance_platform   = "Linux/UNIX"
  availability_zone   = var.availability_zone
  instance_count      = 5
  reservation_type    = "default"
}
```

## Scenario 4: Disaster Recovery

Implement backup and recovery procedures.

```hcl
# Automated daily snapshots
resource "aws_dlm_lifecycle_policy" "ebs_snapshots" {
  execution_role_arn = aws_iam_role.dlm.arn
  description        = "Daily EBS snapshots"
  state               = "ENABLED"

  policy_details {
    policy_type = "EBS_SNAPSHOT_MANAGEMENT"

    resource_types = ["VOLUME"]

    schedule {
      name = "daily"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["03:00"]
      }

      retain_rule {
        count = 7
      }

      tags_to_add = {
        SnapshotType = "Automated"
      }
    }
  }
}

# Cross-region backup
resource "aws_backup_vault" "primary" {
  name = "primary-vault"
}

resource "aws_backup_vault" "secondary" {
  name = "secondary-vault"
}

resource "aws_backup_plan" "main" {
  name = "main-backup-plan"

  rule {
    rule_name       = "daily_backup"
    target_vault_name = aws_backup_vault.primary.name
    schedule        = "cron(0 5 ? * *)"
    start_window    = 60
    completion_window = 120

    lifecycle {
      cold_storage_after = 30
      delete_after       = 90
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.secondary.arn

      lifecycle {
        cold_storage_after = 30
        delete_after       = 90
      }
    }
  }
}
```

## Lab: Implement Real-World Scenario

1. Choose one scenario to implement
2. Design architecture
3. Write Terraform configuration
4. Deploy and test
5. Document runbooks for operations

---

Estimated Time: 4-5 hours
