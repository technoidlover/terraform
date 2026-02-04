# Day 11: AWS EC2 Basic

Launch and manage EC2 instances in AWS with Terraform.

## Key Topics

1. EC2 Instances
2. Key Pairs
3. Security Groups
4. Elastic IPs
5. Instance Profiles

## EC2 Instances

```hcl
resource "aws_instance" "web" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              EOF
  )

  tags = {
    Name = "web-server"
  }
}
```

## Key Pairs

```hcl
# Create key pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Generate new key pair
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "generated-key"
  public_key = tls_private_key.main.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.main.private_key_pem
  sensitive = true
}
```

## Security Groups

```hcl
resource "aws_security_group" "web" {
  name = "web-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}
```

## Lab: Complete EC2 Setup

Follow the detailed guide in main.tf, variables.tf, and outputs.tf in this directory.

---

Estimated Time: 3 hours
