# Day 20: Terraform Variables - GCP Load Balancer and Auto Scaling

project_id             = "my-project-id"
gcp_region             = "us-central1"
gcp_zone               = "us-central1-a"
app_name               = "my-app"
environment            = "dev"
machine_type           = "e2-small"
boot_disk_size         = 20

# References to Day 19 infrastructure
vpc_network            = "my-app-vpc"
vpc_subnetwork         = "my-app-subnet"
service_account_email  = "my-app-sa@my-project-id.iam.gserviceaccount.com"

# Auto Scaling Configuration
target_size            = 2
min_replicas           = 2
max_replicas           = 5
target_cpu_utilization = 0.7
