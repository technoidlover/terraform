# Day 20: GCP Compute and Storage

Deploy Compute Engine instances and Cloud Storage with Terraform.

## Key Topics

1. Compute Engine Instances
2. Cloud Storage Buckets
3. Cloud SQL
4. Firewall Rules
5. Networks

## Compute Engine

```hcl
resource "google_compute_instance" "app" {
  name         = "app-instance"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  network_interface {
    network = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.main.name

    access_config {}  # Public IP
  }

  metadata_startup_script = <<-EOF
                          #!/bin/bash
                          apt-get update
                          apt-get install -y curl wget
                          EOF

  tags = ["http", "https"]
}
```

## Cloud Storage

```hcl
resource "google_storage_bucket" "data" {
  name          = "my-data-bucket-${data.google_client_config.default.project}"
  location      = "US"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_object" "file" {
  name   = "test.txt"
  bucket = google_storage_bucket.data.name
  source = "test.txt"
}
```

## Cloud SQL

```hcl
resource "google_sql_database_instance" "mysql" {
  name             = "my-database"
  database_version = "MYSQL_8_0"
  region           = var.gcp_region

  settings {
    tier      = "db-f1-micro"
    disk_size = 20

    database_flags {
      name  = "max_connections"
      value = "100"
    }
  }
}

resource "google_sql_database" "db" {
  name      = "myapp"
  instance  = google_sql_database_instance.mysql.name
  charset   = "utf8mb4"
  collation = "utf8mb4_unicode_ci"
}

resource "google_sql_user" "root" {
  name     = "root"
  instance = google_sql_database_instance.mysql.name
  password = random_password.db.result
}
```

## Lab: Complete GCP Stack

Deploy Compute Engine, Cloud Storage, and Cloud SQL in a single configuration.

---

Estimated Time: 3-4 hours
