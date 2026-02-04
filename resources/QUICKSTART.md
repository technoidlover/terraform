# Quick Start Guide

Follow these steps to get started with the Terraform 30-day course.

## Prerequisites Checklist

Before starting, verify you have:

- [ ] Windows 10/11 or Linux/macOS
- [ ] Administrator access
- [ ] At least 5 GB free disk space
- [ ] Stable internet connection
- [ ] Code editor (VS Code recommended)
- [ ] Git installed
- [ ] AWS account (free tier) or alternative cloud provider

## Step 1: Install Terraform

### Option A: Chocolatey (Windows)

```powershell
# Open PowerShell as Administrator
choco install terraform

# Verify
terraform -v
```

### Option B: Manual Download

1. Visit https://www.terraform.io/downloads.html
2. Download Windows binary
3. Extract to a folder (e.g., C:\Terraform)
4. Add to PATH environment variable
5. Verify in terminal: `terraform -v`

### Option C: Using tfenv (Version Manager)

Windows users should use tfenv-windows:
https://github.com/tfutils/tfenv-windows

## Step 2: Configure AWS Credentials

### Option A: AWS CLI

```powershell
# Install AWS CLI
choco install awscli

# Configure credentials
aws configure

# When prompted, enter:
# AWS Access Key ID: <your-key>
# AWS Secret Access Key: <your-secret>
# Default region: us-east-1
# Default output format: json

# Verify
aws sts get-caller-identity
```

### Option B: Environment Variables

```powershell
$env:AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
$env:AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
$env:AWS_DEFAULT_REGION = "us-east-1"
```

### Option C: AWS Credentials File

Create `~\.aws\credentials`:

```
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[myprofile]
aws_access_key_id = AKIA...
aws_secret_access_key = ...
```

## Step 3: Set Up Development Environment

### Install VS Code Extensions

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for and install:
   - Terraform (HashiCorp)
   - AWS Toolkit
   - GitLens
   - Remote - WSL (if using WSL)

### Create Workspace

```powershell
# Navigate to course directory
cd E:\terraform

# Initialize git
git init

# Create first directory
mkdir day-01-test
cd day-01-test

# Create basic configuration
terraform init
```

## Step 4: Run First Configuration

### Create test.tf

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Simple data source to test connection
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "user_arn" {
  value = data.aws_caller_identity.current.arn
}
```

### Run Commands

```powershell
# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan

# You should see output showing your AWS account
```

## Step 5: Start Learning

```powershell
# Navigate to Day 1
cd E:\terraform\day-01-terraform-basics-and-setup

# Read the README
type README.md

# Start with the main.tf file
# Read through it carefully

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Create a plan
terraform plan

# Review plan output carefully
```

## Day-by-Day Quick Start

### For Each Day:

1. Navigate to day directory:
   ```powershell
   cd E:\terraform\day-XX-topic
   ```

2. Read documentation:
   ```powershell
   type README.md
   ```

3. Review files:
   - main.tf (resource definitions)
   - variables.tf (input variables)
   - outputs.tf (output values)

4. Initialize (if first time):
   ```powershell
   terraform init
   ```

5. Validate:
   ```powershell
   terraform validate
   ```

6. Plan:
   ```powershell
   terraform plan
   ```

7. Study before applying:
   - Read the plan output
   - Understand what will be created
   - Check costs if relevant

8. Apply (only if comfortable):
   ```powershell
   terraform apply
   ```

9. Verify in AWS console

10. Clean up when done:
    ```powershell
    terraform destroy
    ```

## Course Structure

The course is organized as follows:

```
E:\terraform\
├── README.md (Overview and course guide)
├── day-01-terraform-basics-and-setup/
├── day-02-provider-configuration/
├── ... (days 3-29)
├── day-30-capstone-project/
└── resources/
    ├── STUDY_GUIDE.md (This file)
    └── templates/
```

## Recommended IDE Setup

### VS Code Settings

Create `.vscode/settings.json`:

```json
{
  "[hcl]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "hashicorp.terraform"
  },
  "[terraform]": {
    "editor.formatOnSave": true
  },
  "terraform.experimentalFeatures.prefillRequiredFields": true,
  "terraform.languageServer": true
}
```

## Common Issues and Solutions

### Issue: "terraform: The term 'terraform' is not recognized"

Solution:
1. Verify installation: `where terraform`
2. Add to PATH if needed
3. Restart terminal
4. Try again

### Issue: AWS credentials not found

Solution:
```powershell
# Verify credentials
aws sts get-caller-identity

# Check environment variables
$env:AWS_ACCESS_KEY_ID
$env:AWS_SECRET_ACCESS_KEY

# Or check credentials file
type $env:USERPROFILE\.aws\credentials
```

### Issue: Provider not found during init

Solution:
```powershell
# Clear Terraform cache
rm -r .terraform

# Reinitialize
terraform init

# If still failing, try:
terraform init -upgrade
```

### Issue: Permission denied creating resources

Solution:
1. Verify IAM permissions in AWS console
2. Check if IAM user has necessary permissions
3. Ensure credentials are for correct account

## Next Steps

1. Complete today's course material
2. Move to next day sequentially
3. Complete all exercises
4. Work on capstone project
5. Review and consolidate learning

## Getting Help

If you get stuck:

1. Read error message carefully
2. Check day's README.md
3. Review the code comments
4. Search Terraform documentation
5. Check AWS documentation
6. Ask in forums:
   - [Terraform Community](https://discuss.hashicorp.com/)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/terraform)

## Course Completion Checklist

- [ ] All 30 days completed
- [ ] All exercises done
- [ ] Capstone project deployed
- [ ] All code tested and validated
- [ ] Documentation reviewed
- [ ] Best practices understood
- [ ] Ready for production use

## Recommended Study Schedule

- Week 1: Days 1-5 (Fundamentals)
- Week 2: Days 6-10 (Advanced concepts)
- Week 3: Days 11-22 (Cloud providers and projects)
- Week 4: Days 23-30 (Enterprise features and capstone)

Each day requires approximately 3-4 hours of focused study.

## Final Notes

- Progress at your own pace
- Don't rush through material
- Practice and experiment with code
- Keep costs in mind (use free tier)
- Always clean up after labs
- Document your learning
- Build your portfolio
- Share your knowledge

Good luck with your Terraform learning journey!

---

Last Updated: February 2026
