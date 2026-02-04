# Day 12: AWS RDS - Outputs

output "mysql_endpoint" {
  description = "MySQL database endpoint"
  value       = try(aws_db_instance.mysql[0].endpoint, null)
}

output "mysql_address" {
  description = "MySQL database address"
  value       = try(aws_db_instance.mysql[0].address, null)
}

output "mysql_port" {
  description = "MySQL database port"
  value       = try(aws_db_instance.mysql[0].port, null)
}

output "mysql_identifier" {
  description = "MySQL database identifier"
  value       = try(aws_db_instance.mysql[0].identifier, null)
}

output "postgresql_endpoint" {
  description = "PostgreSQL database endpoint"
  value       = try(aws_db_instance.postgresql[0].endpoint, null)
}

output "postgresql_address" {
  description = "PostgreSQL database address"
  value       = try(aws_db_instance.postgresql[0].address, null)
}

output "postgresql_port" {
  description = "PostgreSQL database port"
  value       = try(aws_db_instance.postgresql[0].port, null)
}

output "postgresql_identifier" {
  description = "PostgreSQL database identifier"
  value       = try(aws_db_instance.postgresql[0].identifier, null)
}

output "db_subnet_group_name" {
  description = "Database subnet group name"
  value       = aws_db_subnet_group.main.name
}

output "security_group_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds.id
}

output "rds_master_password" {
  description = "RDS master password"
  value       = random_password.rds.result
  sensitive   = true
}

output "rds_summary" {
  description = "RDS instances summary"
  value = {
    mysql_enabled      = var.enable_mysql
    postgresql_enabled = var.enable_postgresql
    production         = var.production_environment
  }
}
