# Day 19: GCP Project Part 1 - Compute Engine and Networking
# Creates GCP infrastructure with Compute Engine, VPC, and firewall rules

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configure GCP provider
provider "google" {
  project = var.project_id
  region  = var.gcp_region
}

# Data source for GCP project
data "google_client_config" "default" {}

# GCP Project variable
variable "project_id" {
  description = "GCP Project ID"
  type        = string

  validation {
    condition     = length(var.project_id) > 0
    error_message = "Project ID cannot be empty."
  }
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+\\d$", var.gcp_region))
    error_message = "GCP region must be valid format (e.g., us-central1)."
  }
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "GCE instance machine type"
  type        = string
  default     = "e2-small"

  validation {
    condition     = can(regex("^e2-", var.machine_type)) || can(regex("^n1-", var.machine_type))
    error_message = "Machine type must be e2 or n1 family."
  }
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.boot_disk_size >= 10
    error_message = "Boot disk size must be at least 10 GB."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-app"
}

# VPC Network
# Creates the main Virtual Private Cloud
resource "google_compute_network" "vpc" {
  name                    = "${var.app_name}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"

  depends_on = [data.google_client_config.default]
}

# Subnet for the VPC
# Defines IP address ranges for resources
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.app_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.vpc.id

  private_ip_google_access = true

  log_config {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }

  depends_on = [google_compute_network.vpc]
}

# Firewall rule to allow SSH
# Permits SSH access from specific IP ranges
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.app_name}-allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.allowed_ssh_cidrs
  target_tags   = ["ssh"]

  depends_on = [google_compute_network.vpc]
}

# Firewall rule to allow HTTP
resource "google_compute_firewall" "allow_http" {
  name    = "${var.app_name}-allow-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]

  depends_on = [google_compute_network.vpc]
}

# Firewall rule to allow HTTPS
resource "google_compute_firewall" "allow_https" {
  name    = "${var.app_name}-allow-https"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]

  depends_on = [google_compute_network.vpc]
}

# Get latest Debian image
data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

# Service account for GCE instances
# Provides identity and permissions for instances
resource "google_service_account" "default" {
  account_id   = "${var.app_name}-sa"
  display_name = "Service Account for ${var.app_name}"
}

# IAM role binding for service account
resource "google_project_iam_member" "default" {
  project = var.project_id
  role    = "roles/compute.osLogin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Compute Engine Instances
# Creates virtual machines with specified configuration
resource "google_compute_instance" "app" {
  count         = var.instance_count
  name          = "${var.app_name}-vm-${count.index + 1}"
  machine_type  = var.machine_type
  zone          = var.gcp_zone

  # Boot disk configuration
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
      size  = var.boot_disk_size
      type  = "pd-standard"
    }
  }

  # Network configuration
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    # Assign public IP for external access
    access_config {
      nat_ip = google_compute_address.static[count.index].address
    }
  }

  # Service account for instance
  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  # Metadata for startup script
  metadata = {
    startup-script = base64encode(templatefile("${path.module}/startup_script.sh", {
      environment = var.environment
      app_name    = var.app_name
    }))
  }

  # Labels for resource organization
  labels = {
    environment = var.environment
    app         = var.app_name
    managed_by  = "terraform"
  }

  # Enable detailed monitoring
  enable_display = false

  depends_on = [
    google_compute_network.vpc,
    google_compute_subnetwork.subnet,
    google_service_account.default
  ]

  tags = ["ssh", "http-server", "https-server"]
}

# Static IP addresses for instances
# Reserves public IPs for consistent access
resource "google_compute_address" "static" {
  count  = var.instance_count
  name   = "${var.app_name}-ip-${count.index + 1}"
  region = var.gcp_region

  depends_on = [data.google_client_config.default]
}

# Cloud Storage bucket for application data
resource "google_storage_bucket" "app_data" {
  name          = "${var.project_id}-${var.app_name}-data"
  location      = var.gcp_region
  force_destroy = false

  # Uniform bucket-level access
  uniform_bucket_level_access = true

  # Encryption with customer-managed keys
  encryption {
    default_kms_key_name = google_kms_crypto_key.bucket_key.id
  }

  # Lifecycle configuration
  lifecycle_rule {
    action {
      type = "SetStorageClass"
      storage_class = "STANDARD"
    }
    condition {
      age = 0
    }
  }

  versioning {
    enabled = true
  }

  labels = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [google_kms_crypto_key.bucket_key]
}

# KMS Keyring for encryption
resource "google_kms_key_ring" "keyring" {
  name     = "${var.app_name}-keyring"
  location = var.gcp_region
}

# KMS Crypto Key for bucket encryption
resource "google_kms_crypto_key" "bucket_key" {
  name            = "${var.app_name}-bucket-key"
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "7776000s" # 90 days

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [google_kms_key_ring.keyring]
}

# Cloud SQL MySQL Instance
# Managed relational database service
resource "google_sql_database_instance" "main" {
  name             = "${var.app_name}-mysql"
  database_version = "MYSQL_8_0"
  region           = var.gcp_region

  settings {
    tier              = var.db_instance_tier
    availability_type = var.enable_ha ? "REGIONAL" : "ZONAL"

    # Backup configuration
    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
    }

    # IP configuration
    ip_configuration {
      require_ssl            = true
      private_network        = google_compute_network.vpc.id
      ipv4_enabled           = false
      authorized_networks {
        name  = "office"
        value = "0.0.0.0/0"
      }
    }

    # Database flags
    database_flags {
      name  = "max_connections"
      value = "1000"
    }

    database_flags {
      name  = "slow_query_log"
      value = "on"
    }

    # Maintenance window
    maintenance_window {
      day          = 1 # Monday
      hour         = 3
      update_track = "stable"
    }
  }

  deletion_protection = true

  depends_on = [google_compute_network.vpc]
}

# Database for the application
resource "google_sql_database" "app_db" {
  name     = "app_database"
  instance = google_sql_database_instance.main.name
  charset  = "utf8mb4"
  collation = "utf8mb4_unicode_ci"

  depends_on = [google_sql_database_instance.main]
}

# Database user
resource "google_sql_user" "app_user" {
  name     = "app_user"
  instance = google_sql_database_instance.main.name
  password = var.db_password

  depends_on = [google_sql_database_instance.main]
}

# Monitoring alert policy
resource "google_monitoring_alert_policy" "cpu_utilization" {
  display_name = "${var.app_name} High CPU"
  combiner     = "OR"

  conditions {
    display_name = "CPU utilization above 80%"

    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = [google_monitoring_notification_channel.email.name]

  depends_on = [google_monitoring_notification_channel.email]
}

# Notification channel for alerts
resource "google_monitoring_notification_channel" "email" {
  display_name = "${var.app_name} Email"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }

  depends_on = [data.google_client_config.default]
}

# Variables for Day 19
variable "subnet_cidr" {
  description = "Subnet CIDR range"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "Subnet CIDR must be valid."
  }
}

variable "allowed_ssh_cidrs" {
  description = "CIDR ranges allowed for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "db_instance_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-f1-micro"
}

variable "enable_ha" {
  description = "Enable high availability for Cloud SQL"
  type        = bool
  default     = false
}

variable "db_password" {
  description = "Database user password"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email for alerts"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must be valid email."
  }
}

# Outputs
output "vpc_id" {
  description = "VPC network ID"
  value       = google_compute_network.vpc.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = google_compute_subnetwork.subnet.id
}

output "instance_names" {
  description = "Names of created instances"
  value       = google_compute_instance.app[*].name
}

output "instance_ips" {
  description = "External IPs of created instances"
  value       = google_compute_address.static[*].address
}

output "instance_internal_ips" {
  description = "Internal IPs of created instances"
  value       = google_compute_instance.app[*].network_interface[0].network_ip
}

output "bucket_name" {
  description = "Cloud Storage bucket name"
  value       = google_storage_bucket.app_data.name
}

output "database_instance_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = google_sql_database_instance.main.connection_name
}

output "database_name" {
  description = "Database name"
  value       = google_sql_database.app_db.name
}

output "database_user" {
  description = "Database username"
  value       = google_sql_user.app_user.name
  sensitive   = true
}

output "service_account_email" {
  description = "Service account email"
  value       = google_service_account.default.email
}
