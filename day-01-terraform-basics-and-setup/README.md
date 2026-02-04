# Day 1: Terraform Basics and Setup

## Learning Objectives

By the end of this day, you will understand:

1. What Terraform is and its purpose
2. Key concepts in Infrastructure as Code (IaC)
3. How Terraform works
4. Installing and configuring Terraform
5. Understanding the Terraform workflow
6. Creating your first Terraform configuration

## Topics Covered

1. Introduction to Terraform
2. Infrastructure as Code concepts
3. Terraform vs other tools
4. Installation and setup
5. Terraform workflow (init, plan, apply, destroy)
6. Basic configuration structure
7. Hello World example

## 1. What is Terraform?

Terraform is an open-source Infrastructure as Code tool created by HashiCorp. It allows you to define, provision, and manage cloud infrastructure using declarative configuration files.

Key characteristics:

- Declarative: You describe the desired state, not the steps
- Platform-agnostic: Works with AWS, Azure, GCP, and 100+ providers
- Version-controlled: Infrastructure code can be tracked in Git
- Idempotent: Running Terraform multiple times produces the same result
- Modular: Code can be organized and reused easily

## 2. Infrastructure as Code (IaC)

IaC is the practice of managing and provisioning infrastructure through code instead of manual processes.

Benefits:

- Reproducibility: Same infrastructure everywhere
- Version control: Track changes to infrastructure
- Documentation: Code serves as infrastructure documentation
- Automation: Faster deployments
- Collaboration: Team can review and approve changes
- Disaster recovery: Quickly rebuild infrastructure
- Cost tracking: Better understanding of resource usage

## 3. Terraform vs Other Tools

| Tool | Type | Approach | Best For |
|------|------|----------|----------|
| Terraform | IaC | Declarative | Multi-cloud, complex infrastructure |
| Ansible | Configuration Mgmt | Imperative | Configuration management, simple deployments |
| CloudFormation | IaC | Declarative | AWS-only environments |
| Pulumi | IaC | Imperative/Declarative | Developers preferring programming languages |
| Chef | Configuration Mgmt | Imperative | Complex configuration management |

## 4. Installation and Setup

### Prerequisites

- Windows 10/11 (or Linux/macOS)
- Administrator access
- Internet connection

### Installation Steps

#### Method 1: Chocolatey (Windows)

```bash
# Install Terraform using Chocolatey
choco install terraform

# Verify installation
terraform -v
```

#### Method 2: Manual Installation

1. Download from https://www.terraform.io/downloads.html
2. Extract the zip file
3. Add Terraform to PATH environment variable
4. Verify installation:
   ```bash
   terraform -v
   ```

#### Method 3: Using tfenv (Version Manager)

```bash
# Install tfenv
# Windows users: use tfenv-windows

# Install latest Terraform
tfenv install latest

# Use specific version
tfenv use 1.5.0

# Verify
terraform -v
```

### System Requirements

- 512 MB minimum RAM
- 50 MB disk space
- Windows, macOS, or Linux
- Admin access for installation

### First Steps After Installation

1. Verify installation:
   ```bash
   terraform -v
   ```

2. Check CLI help:
   ```bash
   terraform --help
   ```

3. List available commands:
   ```bash
   terraform -help
   ```

## 5. Terraform Workflow

The standard Terraform workflow consists of three main steps:

### Step 1: Write (Write IaC Configuration)

Create .tf files describing your infrastructure.

```
Typical Structure:
main.tf          - Main resource definitions
variables.tf     - Input variable declarations
outputs.tf       - Output value declarations
terraform.tfvars - Variable values
```

### Step 2: Plan (Review Changes)

```bash
terraform init   # Initialize working directory
terraform plan   # Preview what will be created/changed/destroyed
```

The plan shows:
- Resources to be added (+)
- Resources to be changed (~)
- Resources to be destroyed (-)

### Step 3: Apply (Create Infrastructure)

```bash
terraform apply  # Create/update resources
```

Terraform compares the desired state (your code) with actual state (deployed infrastructure) and makes necessary changes.

### Step 4: Destroy (Optional, Clean Up)

```bash
terraform destroy # Remove all managed resources
```

### State Management

Terraform tracks resource state in a state file:
- Default: local file called terraform.tfstate
- Contains JSON representation of deployed resources
- Used to determine what changed
- Must be backed up and protected

## 6. Basic Configuration Structure

### File Types

**.tf files** contain HCL (HashiCorp Configuration Language)

#### main.tf

```hcl
# Define the cloud provider
provider "aws" {
  region = "us-east-1"
}

# Define resources to create
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

#### variables.tf

```hcl
# Declare input variables
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}
```

#### outputs.tf

```hcl
# Define output values
output "instance_id" {
  value       = aws_instance.example.id
  description = "The ID of the EC2 instance"
}
```

#### terraform.tfvars

```hcl
# Provide variable values
instance_type = "t2.small"
```

### HCL Syntax Basics

```hcl
# Comments start with #

# Blocks have a type, names, and body
resource "aws_instance" "web" {
  # Arguments define properties
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  # Nested blocks
  tags {
    Name = "web-server"
  }
}

# Variable references use ${} syntax
variable "region" {
  default = "us-east-1"
}

# String interpolation
locals {
  region = var.region
}

# Lists and maps
variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Team        = "platform"
  }
}
```

## 7. Hello World Example

### Complete Hello World Project

Create a directory for this lab:

```bash
mkdir hello-terraform
cd hello-terraform
```

#### File: main.tf

```hcl
# This is our first Terraform configuration
# It creates a simple resource to demonstrate the workflow

# First, specify the required provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Create a simple security group
resource "aws_security_group" "hello" {
  name        = "hello-sg"
  description = "Security group for Hello World example"

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_IP/32"]
  }

  # Allow HTTP inbound
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add tags for organization
  tags = {
    Name = "hello-world-sg"
  }
}

# Create an EC2 instance
resource "aws_instance" "hello" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.hello.id]

  # User data script to run on instance launch
  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Hello from Terraform!" > /var/www/html/index.html
              EOF
  )

  # Add descriptive tags
  tags = {
    Name        = "hello-world-instance"
    Environment = "learning"
  }
}
```

#### File: variables.tf

```hcl
# Input variables for the configuration

# AWS region variable
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

# Instance type variable
variable "instance_type" {
  description = "EC2 instance type to use"
  type        = string
  default     = "t2.micro"
  
  # Validation rule - instance type must be free tier eligible
  validation {
    condition     = can(regex("^t[2-3]\\.", var.instance_type))
    error_message = "Instance type must be t2 or t3 family."
  }
}
```

#### File: outputs.tf

```hcl
# Output values that will be displayed after apply

# Output the instance ID
output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.hello.id
}

# Output the instance public IP
output "instance_public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.hello.public_ip
}

# Output the security group ID
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.hello.id
}
```

#### File: terraform.tfvars

```hcl
# Variable values for this environment
aws_region    = "us-east-1"
instance_type = "t2.micro"
```

#### File: .gitignore

```
# Terraform files to ignore in version control
terraform.tfstate
terraform.tfstate.*
.terraform.lock.hcl
.terraform/
crash.log
crash.*.log
.DS_Store
*.swp
*.swo
*~
.idea/
*.iml
.vscode/
```

### Running the Example

```bash
# Step 1: Initialize the Terraform working directory
terraform init

# This will:
# - Download provider plugins
# - Create .terraform directory
# - Initialize backend

# Step 2: Format and validate the configuration
terraform fmt
terraform validate

# Step 3: Create an execution plan
terraform plan

# This shows what will be created without making changes

# Step 4: Apply the configuration
terraform apply

# Review the plan and type "yes" to proceed

# Step 5: View outputs
terraform output

# Step 6: Destroy resources when done
terraform destroy
```

### Expected Output

After running `terraform apply`, you should see:

```
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-0123456789abcdef0"
instance_public_ip = "54.123.45.67"
security_group_id = "sg-0123456789abcdef0"
```

## Terraform State

After running `terraform apply`, two files are created:

1. **terraform.tfstate**: Current infrastructure state
   - JSON format
   - Contains all resource information
   - Should be backed up
   - Should not be committed to Git (add to .gitignore)

2. **terraform.tfstate.backup**: Previous state backup
   - Useful for recovery

## Common Commands

```bash
# Initialize working directory
terraform init

# Validate configuration syntax
terraform validate

# Format files according to conventions
terraform fmt

# Create execution plan
terraform plan

# Apply configuration
terraform apply

# Destroy resources
terraform destroy

# Show current state
terraform show

# Show specific output
terraform output instance_id

# Show Terraform version
terraform version

# Get help for any command
terraform -help
terraform apply -help
```

## Directory Structure for This Lab

```
hello-terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
└── .gitignore
```

## Best Practices Introduced

1. Organize code into separate files by purpose
2. Use descriptive resource names
3. Add comments explaining complex logic
4. Include tags on resources
5. Use variables for configurable values
6. Provide meaningful output descriptions
7. Ignore sensitive files in version control
8. Validate configurations before applying

## Lab Exercises

### Exercise 1: Create Basic Configuration

Create a new directory and:
1. Write a main.tf with provider block
2. Create a variables.tf with two variables
3. Create an outputs.tf with one output
4. Run terraform init and validate

### Exercise 2: Modify the Example

1. Change the instance type in terraform.tfvars
2. Run terraform plan to see changes
3. Observe what resources would change

### Exercise 3: Add Another Resource

1. Add another aws_security_group with different rules
2. Reference it in the security group list
3. Plan and understand the changes

### Exercise 4: Clean Up

1. Run terraform destroy
2. Verify resources are deleted in AWS console
3. Check that terraform.tfstate still exists locally

## Troubleshooting

### Problem: "terraform command not found"

Solution:
```bash
# Verify Terraform is installed
terraform -v

# If not found, check PATH environment variable
echo %PATH%

# Reinstall Terraform and add to PATH
```

### Problem: AWS credentials not found

Solution:
```bash
# Configure AWS credentials
aws configure

# Or set environment variables
set AWS_ACCESS_KEY_ID=your_access_key
set AWS_SECRET_ACCESS_KEY=your_secret_key
```

### Problem: Provider not found

Solution:
```bash
# Reinitialize to download providers
terraform init

# Force redownload
terraform init -upgrade
```

## Key Takeaways

1. Terraform is a declarative Infrastructure as Code tool
2. The basic workflow is: Write, Plan, Apply
3. Configuration is written in HCL language
4. State files track what's been deployed
5. Variables make configurations reusable
6. Outputs expose important values
7. Always validate before applying
8. Plan before you apply to see changes

## Next Steps

1. Complete all exercises above
2. Ensure you can run terraform init, plan, and apply
3. Understand the workflow
4. Proceed to Day 2 when ready

## Additional Resources

- Terraform language documentation: https://www.terraform.io/language
- AWS provider documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- HashiCorp Learn: https://learn.hashicorp.com/terraform
- Terraform CLI docs: https://www.terraform.io/cli

---

Estimated Time: 3-4 hours including exercises
Prerequisites completed: Terraform installed and AWS account ready
Next: Day 2 - Provider Configuration
