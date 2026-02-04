# Day 14: AWS Load Balancer and Auto Scaling - Outputs

output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.main.arn"
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "asg_min_size" {
  description = "Minimum ASG size"
  value       = aws_autoscaling_group.main.min_size
}

output "asg_max_size" {
  description = "Maximum ASG size"
  value       = aws_autoscaling_group.main.max_size
}

output "asg_desired_capacity" {
  description = "Desired ASG capacity"
  value       = aws_autoscaling_group.main.desired_capacity
}

output "load_balancer_url" {
  description = "URL of the load balancer"
  value       = "http://${aws_lb.main.dns_name}"
}

output "infrastructure_summary" {
  description = "Summary of load balancing infrastructure"
  value = {
    alb_dns                = aws_lb.main.dns_name
    asg_name              = aws_autoscaling_group.main.name
    min_instances         = var.min_size
    max_instances         = var.max_size
    desired_instances     = var.desired_capacity
    instance_type         = var.instance_type
  }
}
