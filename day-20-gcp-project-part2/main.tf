# Day 20: GCP Project Part 2 - Load Balancer and Auto Scaling
# Creates HTTP(S) load balancer, instance templates, and managed instance groups

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.gcp_region
}

data "google_client_config" "default" {}

# Health check for load balancer
# Monitors backend health
resource "google_compute_health_check" "app" {
  name        = "${var.app_name}-health-check"
  description = "Health check for ${var.app_name}"

  http_health_check {
    port               = 8080
    request_path       = "/health"
    check_interval_sec = 30
    timeout_sec        = 5
  }

  depends_on = [data.google_client_config.default]
}

# Instance template for managed instance group
# Defines configuration for scaling instances
resource "google_compute_instance_template" "app" {
  name_prefix  = "${var.app_name}-template-"
  machine_type = var.machine_type

  disk {
    source_image = data.google_compute_image.debian.self_link
    disk_size_gb = var.boot_disk_size
    disk_type    = "pd-standard"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.vpc_network
    subnetwork = var.vpc_subnetwork

    access_config {
      # Public IP for instances
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = ["cloud-platform"]
  }

  metadata = {
    startup-script = base64encode(templatefile("${path.module}/startup.sh", {
      app_port = 8080
    }))
  }

  labels = {
    environment = var.environment
    app         = var.app_name
  }

  depends_on = [data.google_client_config.default]

  lifecycle {
    create_before_destroy = true
  }
}

# Get latest Debian image
data "google_compute_image" "debian" {
  family  = "debian-12"
  project = "debian-cloud"
}

# Managed Instance Group
# Auto-scales instances based on metrics
resource "google_compute_instance_group_manager" "app" {
  name               = "${var.app_name}-igm"
  instance_template = google_compute_instance_template.app.id
  base_instance_name = "${var.app_name}-instance"
  zone               = var.gcp_zone
  target_size        = var.target_size

  auto_healing_policies {
    health_check      = google_compute_health_check.app.id
    initial_delay_sec = 300
  }

  named_port {
    name = "http"
    port = 8080
  }

  depends_on = [google_compute_instance_template.app, google_compute_health_check.app]
}

# Autoscaling policy for managed instance group
resource "google_compute_autoscaler" "app" {
  name       = "${var.app_name}-autoscaler"
  zone       = var.gcp_zone
  target     = google_compute_instance_group_manager.app.id

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = 60

    cpu_utilization {
      target = var.target_cpu_utilization
    }
  }

  depends_on = [google_compute_instance_group_manager.app]
}

# Backend service
# Routes traffic to managed instance group
resource "google_compute_backend_service" "app" {
  name                  = "${var.app_name}-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  connection_draining_timeout_sec = 300

  health_checks = [google_compute_health_check.app.id]

  backend {
    group                        = google_compute_instance_group_manager.app.instance_group
    balancing_mode               = "UTILIZATION"
    max_utilization              = 0.8
    capacity_scaler              = 1.0
  }

  log_config {
    enable      = true
    sample_rate = 1.0
  }

  depends_on = [google_compute_health_check.app, google_compute_instance_group_manager.app]
}

# URL map for routing
resource "google_compute_url_map" "app" {
  name            = "${var.app_name}-url-map"
  default_service = google_compute_backend_service.app.id

  depends_on = [google_compute_backend_service.app]
}

# HTTP proxy for forwarding rules
resource "google_compute_target_http_proxy" "app" {
  name   = "${var.app_name}-http-proxy"
  url_map = google_compute_url_map.app.id

  depends_on = [google_compute_url_map.app]
}

# Global forwarding rule
resource "google_compute_global_forwarding_rule" "app" {
  name                  = "${var.app_name}-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.app.id

  depends_on = [google_compute_target_http_proxy.app]
}

# Static global IP for load balancer
resource "google_compute_global_address" "app" {
  name = "${var.app_name}-lb-ip"

  depends_on = [data.google_client_config.default]
}

# Firewall rule for load balancer health checks
resource "google_compute_firewall" "allow_health_checks" {
  name    = "${var.app_name}-allow-health-checks"
  network = var.vpc_network

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  # Google Cloud health check IPs
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = ["http-server"]

  depends_on = [data.google_client_config.default]
}

# Firewall rule for load balancer traffic
resource "google_compute_firewall" "allow_lb_traffic" {
  name    = "${var.app_name}-allow-lb-traffic"
  network = var.vpc_network

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]

  depends_on = [data.google_client_config.default]
}

# Cloud Monitoring Dashboard
resource "google_monitoring_dashboard" "app" {
  dashboard_json = jsonencode({
    displayName = "${var.app_name} Dashboard"
    mosaicLayout = {
      columns = 12
      tiles = [
        {
          width  = 6
          height = 4
          widget = {
            title = "CPU Utilization"
            xyChart = {
              dataSets = [{
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
                  }
                }
              }]
            }
          }
        },
        {
          xPos   = 6
          width  = 6
          height = 4
          widget = {
            title = "Memory Utilization"
            xyChart = {
              dataSets = [{
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    filter = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\""
                  }
                }
              }]
            }
          }
        }
      ]
    }
  })

  depends_on = [data.google_client_config.default]
}

# Input Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "my-app"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "machine_type" {
  description = "Machine type for instances"
  type        = string
  default     = "e2-small"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "vpc_network" {
  description = "VPC network name"
  type        = string
}

variable "vpc_subnetwork" {
  description = "VPC subnetwork name"
  type        = string
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
}

variable "target_size" {
  description = "Target size for instance group"
  type        = number
  default     = 2
}

variable "min_replicas" {
  description = "Minimum replicas"
  type        = number
  default     = 2

  validation {
    condition     = var.min_replicas >= 1
    error_message = "Min replicas must be at least 1."
  }
}

variable "max_replicas" {
  description = "Maximum replicas"
  type        = number
  default     = 5

  validation {
    condition     = var.max_replicas >= var.min_replicas
    error_message = "Max replicas must be >= min replicas."
  }
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization (0-1)"
  type        = number
  default     = 0.7

  validation {
    condition     = var.target_cpu_utilization > 0 && var.target_cpu_utilization <= 1
    error_message = "Target CPU must be between 0 and 1."
  }
}

# Outputs
output "load_balancer_ip" {
  description = "Load balancer IP address"
  value       = google_compute_global_address.app.address
}

output "load_balancer_url" {
  description = "Load balancer URL"
  value       = "http://${google_compute_global_address.app.address}"
}

output "instance_group_manager" {
  description = "Instance group manager name"
  value       = google_compute_instance_group_manager.app.name
}

output "autoscaler_name" {
  description = "Autoscaler name"
  value       = google_compute_autoscaler.app.name
}

output "backend_service_name" {
  description = "Backend service name"
  value       = google_compute_backend_service.app.name
}

output "monitoring_dashboard_id" {
  description = "Monitoring dashboard ID"
  value       = google_monitoring_dashboard.app.dashboard_json
}
