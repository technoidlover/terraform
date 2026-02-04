# Variable values file
# File gia tri bien

# Override default values
# Ghi de cac gia tri mac dinh

environment     = "staging"
instance_count  = 3
enable_monitoring = true

availability_zones = [
  "us-west-2a",
  "us-west-2b"
]

tags = {
  Project     = "Terraform 30 Days"
  Environment = "Staging"
  Owner       = "DevOps Team"
  ManagedBy   = "Terraform"
}

server_config = {
  name     = "staging-server"
  port     = 9090
  protocol = "https"
}

# Sensitive values should not be committed
# Cac gia tri nhay cam khong nen duoc commit
# api_key = "your-actual-api-key-here"
