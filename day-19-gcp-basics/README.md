# Day 19: GCP Basics

Introduction to Google Cloud Platform and Terraform provider setup.

## Key Topics

1. GCP Provider Configuration
2. Service Accounts
3. Projects and APIs
4. Authentication Methods

## Provider Configuration

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
```

## Service Account

```hcl
# Create service account
resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "Terraform Service Account"
}

# Create key
resource "google_service_account_key" "terraform" {
  service_account_id = google_service_account.terraform.name
}

# Grant roles
resource "google_project_iam_member" "terraform" {
  project = var.gcp_project
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.terraform.email}"
}
```

## Authentication

```bash
# Using service account key
export GOOGLE_APPLICATION_CREDENTIALS="path/to/key.json"

# Using gcloud auth
gcloud auth application-default login
```

## Lab: GCP Setup

1. Create service account
2. Generate and save key
3. Configure Terraform provider
4. Test with simple resource creation

---

Estimated Time: 2 hours
