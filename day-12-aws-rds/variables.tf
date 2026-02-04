# Day 12: AWS RDS - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "production_environment" {
  description = "Whether this is production environment"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Make DB publicly accessible"
  type        = bool
  default     = false
}

# MySQL Configuration
variable "enable_mysql" {
  description = "Enable MySQL database"
  type        = bool
  default     = true
}

variable "mysql_identifier" {
  description = "MySQL database identifier"
  type        = string
  default     = "day12-mysql-db"
}

variable "mysql_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.35"
}

variable "mysql_instance_class" {
  description = "MySQL instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "mysql_allocated_storage" {
  description = "MySQL allocated storage GB"
  type        = number
  default     = 20
}

variable "mysql_db_name" {
  description = "MySQL database name"
  type        = string
  default     = "mydb"
}

variable "mysql_username" {
  description = "MySQL master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

# PostgreSQL Configuration
variable "enable_postgresql" {
  description = "Enable PostgreSQL database"
  type        = bool
  default     = true
}

variable "postgresql_identifier" {
  description = "PostgreSQL database identifier"
  type        = string
  default     = "day12-postgresql-db"
}

variable "postgresql_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.3"
}

variable "postgresql_instance_class" {
  description = "PostgreSQL instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "postgresql_allocated_storage" {
  description = "PostgreSQL allocated storage GB"
  type        = number
  default     = 20
}

variable "postgresql_db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "postgres"
}

variable "postgresql_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "postgres"
  sensitive   = true
}
