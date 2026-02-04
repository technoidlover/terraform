aws_region       = "us-east-1"
create_instances = true
instance_count   = 2
instance_type    = "t3.micro"

bucket_config = {
  production = {
    environment         = "prod"
    enable_versioning   = true
  }
  staging = {
    environment         = "stage"
    enable_versioning   = true
  }
  development = {
    environment         = "dev"
    enable_versioning   = false
  }
}
