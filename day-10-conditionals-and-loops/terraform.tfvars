aws_region    = "us-east-1"
environment   = "development"
project_name  = "day10-project"
create_vpc    = true
enable_igw    = true
vpc_cidr      = "10.0.0.0/16"
restrict_egress = false
create_instances = true

subnets = {
  subnet-1a = {
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  }
  subnet-1b = {
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1b"
  }
}

security_group_rules = {
  http = {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
  }
  https = {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
  }
  ssh = {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_ipv4 = "0.0.0.0/0"
  }
}

instances = {
  web-server-1 = {
    instance_type = "t3.micro"
    subnet_key    = "subnet-1a"
    role          = "web"
  }
  app-server-1 = {
    instance_type = "t3.small"
    subnet_key    = "subnet-1b"
    role          = "app"
  }
}

db_name     = "mydb"
db_username = "admin"
db_password = "changeme123!"
