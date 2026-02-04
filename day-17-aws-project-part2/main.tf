# Day 17: AWS Project Part 2 - Load Balancer, EC2 Instances, and Database
# This file creates ALB, EC2 instances in auto-scaling group, RDS database, and ElastiCache

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
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      CreatedDate = timestamp()
    }
  }
}

# Data source to reference Day 16 VPC infrastructure
# In production, use remote state or data source
data "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

data "aws_subnets" "public" {
  filter {
    name   = "cidr-block"
    values = var.public_subnet_cidrs
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "cidr-block"
    values = var.private_subnet_cidrs
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

data "aws_subnets" "database" {
  filter {
    name   = "cidr-block"
    values = var.database_subnet_cidrs
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Application Load Balancer
# Distributes incoming traffic across EC2 instances
resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.public.ids

  enable_deletion_protection = var.enable_alb_deletion_protection
  enable_http2              = true
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "${var.project_name}-alb"
  }

  depends_on = [aws_security_group.alb]
}

# ALB Target Group
# Defines how the load balancer routes traffic to EC2 instances
resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "instance"

  # Health check configuration
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/health"
    matcher             = "200"
  }

  # Connection draining
  deregistration_delay = 30

  tags = {
    Name = "${var.project_name}-app-tg"
  }

  depends_on = [aws_lb.main]
}

# ALB Listener
# Routes HTTP traffic to the target group
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  depends_on = [aws_lb.main, aws_lb_target_group.app]
}

# IAM Role for EC2 instances
# Allows EC2 instances to access other AWS services
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

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
    Name = "${var.project_name}-ec2-role"
  }
}

# IAM Policy for CloudWatch logs
resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "${var.project_name}-cloudwatch-logs"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
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
}

# IAM Role Policy for SSM Session Manager
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Launch Template for Auto Scaling Group
# Defines how EC2 instances are launched
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  # VPC settings
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app.id]
    delete_on_termination       = true
  }

  # IAM instance profile
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  # User data script to configure the instance
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    app_port = 8080
  }))

  # Root volume configuration
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      delete_on_termination = true
      encrypted             = true
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-app-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name = "${var.project_name}-app-volume"
    }
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_iam_instance_profile.ec2_profile, aws_security_group.app]
}

# Auto Scaling Group
# Automatically scales the number of EC2 instances based on demand
resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-asg"
  vpc_zone_identifier = data.aws_subnets.private.ids
  target_group_arns   = [aws_lb_target_group.app.arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  # Scaling policies for automatic scaling
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.app, aws_lb_target_group.app]
}

# CloudWatch Target Tracking Scaling Policy
# Scales based on CPU utilization
resource "aws_autoscaling_policy" "cpu_scaling" {
  name                   = "${var.project_name}-cpu-scaling"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.target_cpu_utilization
  }
}

# RDS DB Subnet Group
# Specifies which subnets RDS can use
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = data.aws_subnets.database.ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }

  depends_on = [data.aws_subnets.database]
}

# RDS MySQL Database Instance
# Creates a managed relational database
resource "aws_db_instance" "main" {
  identifier             = "${var.project_name}-mysql"
  engine                 = "mysql"
  engine_version         = var.mysql_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = "gp3"
  storage_encrypted      = true

  # Database configuration
  db_name  = var.db_name
  username = var.db_username
  # Password from variable (should use AWS Secrets Manager in production)
  password = var.db_password

  # Backup and maintenance
  backup_retention_period = var.backup_retention_days
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"
  
  # High availability
  multi_az = var.enable_multi_az

  # Security
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false

  # Performance Insights
  performance_insights_enabled = var.enable_performance_insights

  # Deletion protection
  deletion_protection = var.enable_deletion_protection

  # Enable CloudWatch logs
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  skip_final_snapshot = var.skip_final_snapshot

  tags = {
    Name = "${var.project_name}-mysql"
  }

  depends_on = [aws_db_subnet_group.main, aws_security_group.rds]
}

# ElastiCache Subnet Group
# Specifies which subnets ElastiCache can use
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-cache-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "${var.project_name}-cache-subnet-group"
  }

  depends_on = [data.aws_subnets.private]
}

# ElastiCache Redis Cluster
# Creates a managed in-memory cache for improved application performance
resource "aws_elasticache_cluster" "main" {
  cluster_id           = "${var.project_name}-redis"
  engine               = "redis"
  node_type            = var.cache_node_type
  num_cache_nodes      = var.cache_num_nodes
  parameter_group_name = "default.redis7"
  engine_version       = var.redis_version
  port                 = 6379

  # Security and networking
  subnet_group_name          = aws_elasticache_subnet_group.main.name
  security_group_ids         = [aws_security_group.cache.id]
  
  # Backup and maintenance
  automatic_failover_enabled = var.cache_num_nodes > 1 ? true : false
  maintenance_window        = "mon:03:00-mon:04:00"
  snapshot_retention_limit   = var.cache_snapshot_retention_days

  # CloudWatch logs
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.cache_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
    enabled          = true
  }

  notification_topic_arn = aws_sns_topic.cache_notifications.arn

  tags = {
    Name = "${var.project_name}-redis"
  }

  depends_on = [aws_elasticache_subnet_group.main, aws_security_group.cache]
}

# CloudWatch Log Group for Cache
resource "aws_cloudwatch_log_group" "cache_logs" {
  name              = "/aws/elasticache/${var.project_name}-redis"
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-cache-logs"
  }
}

# SNS Topic for Cache Notifications
resource "aws_sns_topic" "cache_notifications" {
  name = "${var.project_name}-cache-notifications"

  tags = {
    Name = "${var.project_name}-cache-notifications"
  }
}

# CloudWatch Alarm for ALB Target Health
resource "aws_cloudwatch_metric_alarm" "target_health" {
  alarm_name          = "${var.project_name}-target-health"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  alarm_description   = "Alert when healthy host count falls below 1"

  dimensions = {
    LoadBalancer  = aws_lb.main.arn_suffix
    TargetGroup   = aws_lb_target_group.app.arn_suffix
  }

  depends_on = [aws_lb.main, aws_lb_target_group.app]
}
