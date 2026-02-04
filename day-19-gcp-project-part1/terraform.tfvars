# Day 19: Terraform Variables - GCP Project Part 1

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# GCP Configuration
project_id   = "my-project-id" # UPDATE with your GCP project ID
gcp_region   = "us-central1"
gcp_zone     = "us-central1-a"
environment  = "dev"
app_name     = "my-app"

# Compute Engine Configuration
machine_type   = "e2-small"
instance_count = 2
boot_disk_size = 20

# Network Configuration
subnet_cidr        = "10.0.1.0/24"
allowed_ssh_cidrs  = ["0.0.0.0/0"]

# Cloud SQL Configuration
db_instance_tier = "db-f1-micro"
enable_ha        = false
db_password      = "ChangeMe@123456" # Use strong password in production

# Alerts
alert_email = "admin@example.com"
