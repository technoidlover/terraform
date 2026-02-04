# Day 3: Variables and Outputs - Variable Values

aws_region      = "us-east-1"
environment     = "development"
project_name    = "day3-project"
vpc_cidr        = "10.0.0.0/16"
subnet_cidrs    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
allowed_ports   = [22, 80, 443]
allowed_cidr    = "0.0.0.0/0"
instance_count  = 2
instance_type   = "t3.micro"
root_volume_type = "gp3"
root_volume_size = 20
