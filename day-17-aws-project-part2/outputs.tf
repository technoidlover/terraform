# Day 17: Outputs for AWS Project Part 2 - Load Balancer, EC2, and Database

# Application Load Balancer outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

# Application URL
output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_lb.main.dns_name}"
}

# Target Group outputs
output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.app.arn
}

output "target_group_name" {
  description = "Name of the target group"
  value       = aws_lb_target_group.app.name
}

# Auto Scaling Group outputs
output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.app.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.app.id
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.app.latest_version_number
}

# RDS Database outputs
output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "rds_address" {
  description = "RDS database address only (without port)"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS database port"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "Name of the database"
  value       = aws_db_instance.main.db_name
}

output "rds_master_username" {
  description = "Master username of the database"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "rds_instance_identifier" {
  description = "Instance identifier of RDS"
  value       = aws_db_instance.main.identifier
}

output "rds_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "rds_multi_az" {
  description = "Whether RDS is deployed across multiple AZs"
  value       = aws_db_instance.main.multi_az
}

# ElastiCache Redis outputs
output "redis_endpoint" {
  description = "Redis cluster endpoint address"
  value       = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "redis_port" {
  description = "Redis cluster port"
  value       = aws_elasticache_cluster.main.cache_nodes[0].port
}

output "redis_cluster_id" {
  description = "Redis cluster ID"
  value       = aws_elasticache_cluster.main.id
}

output "redis_engine_version" {
  description = "Redis engine version"
  value       = aws_elasticache_cluster.main.engine_version
}

output "redis_connection_string" {
  description = "Redis connection string"
  value       = "${aws_elasticache_cluster.main.cache_nodes[0].address}:${aws_elasticache_cluster.main.cache_nodes[0].port}"
  sensitive   = true
}

# Database connection string for application
output "database_connection_string" {
  description = "Database connection string for application"
  value       = "mysql://${aws_db_instance.main.username}:PASSWORD@${aws_db_instance.main.address}:${aws_db_instance.main.port}/${aws_db_instance.main.db_name}"
  sensitive   = true
}

# Scaling policy outputs
output "cpu_scaling_policy_arn" {
  description = "ARN of the CPU scaling policy"
  value       = aws_autoscaling_policy.cpu_scaling.arn
}

# Complete infrastructure summary
output "infrastructure_summary" {
  description = "Summary of deployed infrastructure"
  value = {
    load_balancer_url    = "http://${aws_lb.main.dns_name}"
    database_endpoint    = aws_db_instance.main.address
    cache_endpoint       = aws_elasticache_cluster.main.cache_nodes[0].address
    asg_name             = aws_autoscaling_group.app.name
    min_instances        = aws_autoscaling_group.app.min_size
    max_instances        = aws_autoscaling_group.app.max_size
    desired_instances    = aws_autoscaling_group.app.desired_capacity
  }
  sensitive = true
}
