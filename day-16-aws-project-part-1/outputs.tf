# Day 16: AWS Project Part 1 - Foundation - Outputs

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = try(aws_nat_gateway.main[*].id, [])
}

output "nat_eips" {
  description = "Elastic IPs for NAT Gateways"
  value       = try(aws_eip.nat[*].public_ip, [])
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "Private route table IDs"
  value       = try(aws_route_table.private[*].id, [])
}

output "project_summary" {
  description = "Project foundation summary"
  value = {
    vpc_id               = aws_vpc.main.id
    public_subnets      = length(aws_subnet.public)
    private_subnets     = length(aws_subnet.private)
    nat_gateways        = var.enable_nat_gateway ? length(aws_nat_gateway.main) : 0
    flow_logs_enabled   = var.enable_flow_logs
  }
}
