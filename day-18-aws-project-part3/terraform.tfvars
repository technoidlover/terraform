# Day 18: Terraform Variables - Monitoring, Logging, Security

aws_region = "us-east-1"
project_name = "multi-tier-app"
environment = "dev"

# CloudWatch Configuration
log_retention_days = 30

# Alert Configuration - UPDATE WITH YOUR EMAIL
alert_email_address = "admin@example.com"

# CloudTrail
enable_cloudtrail = true

# S3 Encryption
enable_s3_encryption = true

# S3 Lifecycle
s3_lifecycle_days = 90
