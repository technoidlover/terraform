aws_region             = "us-east-1"
vpc_cidr               = "10.0.0.0/16"
production_environment = false
publicly_accessible    = false

# MySQL configuration
enable_mysql            = true
mysql_identifier        = "day12-mysql-db"
mysql_engine_version    = "8.0.35"
mysql_instance_class    = "db.t3.micro"
mysql_allocated_storage = 20
mysql_db_name           = "mydb"
mysql_username          = "admin"

# PostgreSQL configuration
enable_postgresql            = true
postgresql_identifier        = "day12-postgresql-db"
postgresql_engine_version    = "15.3"
postgresql_instance_class    = "db.t3.micro"
postgresql_allocated_storage = 20
postgresql_db_name           = "postgres"
postgresql_username          = "postgres"
