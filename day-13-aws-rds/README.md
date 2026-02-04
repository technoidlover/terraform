# Day 13: AWS RDS

Deploy and manage relational databases with AWS RDS.

## Key Topics

1. RDS Instances
2. DB Parameter Groups
3. DB Subnet Groups
4. Multi-AZ Setup
5. Backups and Snapshots

## RDS Instance

```hcl
resource "aws_db_instance" "main" {
  identifier            = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"

  db_name  = "myappdb"
  username = "admin"
  password = random_password.db_password.result

  skip_final_snapshot = false
  final_snapshot_identifier = "mydb-final-snapshot"

  multi_az            = true
  publicly_accessible = false

  tags = {
    Name = "main-database"
  }
}

# Generate random password
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Output password securely
output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}
```

## Lab: Production-Ready RDS

See main.tf for complete multi-AZ RDS setup with backup configuration.

---

Estimated Time: 2-3 hours
