# Terraform 30-Day Learning Course

Complete hands-on Terraform course designed to take you from zero to production-ready infrastructure as code expert.

## Table of Contents

1. [Course Overview](#course-overview)
2. [Prerequisites](#prerequisites)
3. [Course Structure](#course-structure)
4. [Quick Start](#quick-start)
5. [Learning Path](#learning-path)
6. [Resources](#resources)
7. [Troubleshooting](#troubleshooting)

## Course Overview

This comprehensive 30-day course covers:

- Core Terraform concepts and fundamentals
- Provider configuration and management
- Variables, outputs, and state management
- Modules and code organization
- Multi-cloud infrastructure (AWS, GCP, Azure)
- Advanced features and best practices
- Real-world project implementation
- CI/CD integration and automation

Duration: 30 days (flexible, can be completed at your own pace)
Difficulty Level: Beginner to Advanced
Prerequisites: Basic Linux/command-line knowledge, AWS/cloud basics helpful

## Prerequisites

Before starting this course, ensure you have:

1. Terraform installed (version 1.0 or higher)
   ```bash
   terraform -v
   ```

2. A cloud provider account (AWS free tier recommended):
   - AWS Account with access key and secret key
   - Or GCP Project with service account
   - Or Azure subscription with credentials

3. Git installed for version control
   ```bash
   git --version
   ```

4. A text editor or IDE (VS Code recommended)

5. Basic understanding of:
   - Command-line/terminal usage
   - Cloud platform concepts
   - JSON and YAML syntax

## Course Structure

The course is divided into 5 main phases:

### Phase 1: Foundations (Days 1-10)
Core concepts, language features, and fundamentals

### Phase 2: Cloud Providers (Days 11-22)
Deep dive into AWS, GCP, and Azure

### Phase 3: Advanced Features (Days 23-27)
State management, testing, CI/CD integration

### Phase 4: Real-World Applications (Days 28-29)
Best practices and production patterns

### Phase 5: Capstone Project (Day 30)
Comprehensive project implementation

## Quick Start

### Initial Setup

```bash
# 1. Install Terraform (Windows)
# Using Chocolatey:
choco install terraform

# Using manual download:
# Download from https://www.terraform.io/downloads.html

# 2. Verify installation
terraform -v

# 3. Configure AWS credentials (if using AWS)
aws configure

# 4. Navigate to course directory
cd e:\terraform

# 5. Start with Day 1
cd day-01-terraform-basics-and-setup
```

### Running Labs

Each day includes:
- README.md with detailed explanations
- *.tf files with code examples
- terraform.tfvars with sample variables
- Lab instructions and exercises

To run a lab:

```bash
cd day-XX-topic-name
terraform init
terraform plan
terraform apply
```

To clean up:

```bash
terraform destroy
```

## Learning Path

### Week 1: Terraform Essentials

- **Day 1**: Terraform Basics and Setup
  - What is Terraform
  - Installation and configuration
  - Basic workflow
  
- **Day 2**: Provider Configuration
  - Understanding providers
  - Configuring AWS provider
  - Provider versioning
  
- **Day 3**: Variables and Outputs
  - Input variables
  - Output values
  - Type constraints
  
- **Day 4**: Data Sources and Locals
  - Data sources
  - Local values
  - Dynamic data retrieval
  
- **Day 5**: Resource Creation
  - Basic resource syntax
  - Dependencies
  - Resource references
  
- **Day 6**: State Management
  - Terraform state file
  - Remote state
  - State locking
  
- **Day 7**: Modules Introduction
  - Module structure
  - Creating modules
  - Module variables

### Week 2: AWS Deep Dive

- **Day 8**: Modules Advanced
  - Module composition
  - Registry modules
  - Module best practices
  
- **Day 9**: Expressions and Functions
  - String interpolation
  - Built-in functions
  - Expressions
  
- **Day 10**: Conditionals and Loops
  - For expressions
  - For each
  - Conditional logic
  
- **Day 11**: AWS EC2 Basic
  - EC2 instances
  - Key pairs
  - Security groups
  
- **Day 12**: AWS Networking
  - VPCs
  - Subnets
  - Route tables
  - NAT gateways
  
- **Day 13**: AWS RDS
  - Database instances
  - Parameter groups
  - Multi-AZ setup
  
- **Day 14**: AWS S3
  - Buckets and objects
  - Bucket policies
  - Static website hosting

### Week 3: Multi-Cloud & Advanced

- **Day 15**: AWS IAM
  - Users and roles
  - Policies and permissions
  - Service accounts
  
- **Day 16-18**: AWS Project (3-Part)
  - Complete application infrastructure
  - Web tier with load balancing
  - Database tier with RDS
  - Security and networking
  
- **Day 19**: GCP Basics
  - GCP provider setup
  - Projects and APIs
  - Service accounts
  
- **Day 20**: GCP Compute and Storage
  - Compute Engine
  - Storage buckets
  - Cloud SQL
  
- **Day 21**: Azure Basics
  - Azure provider setup
  - Resource groups
  - Subscriptions
  
- **Day 22**: Azure Resources
  - VMs and storage
  - Networking
  - Managed databases

### Week 4: Enterprise Features & Project

- **Day 23**: Terraform Cloud and State
  - Remote state backends
  - Terraform Cloud organization
  - State sharing
  
- **Day 24**: Testing and Validation
  - Terraform validate
  - Terraform fmt
  - Terraform plan analysis
  
- **Day 25**: Workspaces and Environments
  - Workspace management
  - Environment separation
  - Environment-specific configs
  
- **Day 26**: CI/CD Integration
  - GitHub Actions
  - GitLab CI
  - Pipeline automation
  
- **Day 27**: Troubleshooting and Debugging
  - Common errors
  - Debugging techniques
  - Log analysis
  
- **Day 28**: Best Practices
  - Code organization
  - Naming conventions
  - Security practices
  
- **Day 29**: Real-World Scenarios
  - Multi-region deployment
  - Disaster recovery
  - Cost optimization
  
- **Day 30**: Capstone Project
  - Complete infrastructure project
  - All concepts combined
  - Production-ready code

## Resources

### Official Documentation
- [Terraform Official Docs](https://www.terraform.io/docs)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Terraform Registry
- [Public Module Registry](https://registry.terraform.io/modules)
- [Community Providers](https://registry.terraform.io/browse/providers)

### Additional Resources
- [Terraform CLI Documentation](https://www.terraform.io/cli)
- [HashiCorp Learn](https://learn.hashicorp.com/terraform)
- [Terraform Changelog](https://github.com/hashicorp/terraform/releases)

### Cloud Documentation
- [AWS Documentation](https://docs.aws.amazon.com/)
- [GCP Documentation](https://cloud.google.com/docs)
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)

### Tools and Extensions

VS Code Extensions recommended:
- Terraform (by HashiCorp)
- AWS Toolkit
- Azure Tools

## Directory Structure

```
terraform/
├── README.md (this file)
├── day-01-terraform-basics-and-setup/
│   ├── README.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── terraform.tfvars
│   └── lab-exercises.md
├── day-02-provider-configuration/
│   └── ... (similar structure)
├── ... (days 3-30)
└── resources/
    ├── templates/
    │   └── (reusable Terraform templates)
    └── scripts/
        └── (utility scripts)
```

## Troubleshooting

### Common Issues

1. **Terraform command not found**
   - Add Terraform to PATH
   - Verify installation: `terraform -v`

2. **Provider credentials not working**
   - Check AWS credentials: `aws configure`
   - Verify environment variables
   - Check IAM permissions

3. **State lock error**
   - Clear remote state lock if needed
   - Check for concurrent operations

4. **Permission denied errors**
   - Verify IAM roles and policies
   - Check security group rules
   - Verify bucket policies

5. **Module not found**
   - Run `terraform init`
   - Check module source path
   - Verify registry connectivity

### Getting Help

If you encounter issues:

1. Check the day's README.md file
2. Review Terraform documentation
3. Check cloud provider documentation
4. Examine terraform.log file:
   ```bash
   TF_LOG=DEBUG terraform plan
   ```

5. Search Terraform GitHub issues

## Study Tips

1. Follow the course sequentially
2. Complete all exercises for each day
3. Take notes while studying
4. Practice regularly, don't skip days
5. Review previous days before moving forward
6. Use the same cloud account throughout course
7. Keep terraform files organized
8. Use version control (git) for all code
9. Read error messages carefully
10. Experiment and modify examples

## Certificate of Completion

After completing all 30 days and the capstone project, you will have:

- Deep understanding of Terraform ecosystem
- Hands-on experience with multiple cloud providers
- Production-ready infrastructure code
- Knowledge of best practices and patterns
- Ability to design and implement complex infrastructure
- Understanding of advanced features and optimizations

## Course Maintenance

This course is regularly updated with:
- Latest Terraform versions
- New provider features
- Updated best practices
- New examples and scenarios

Last Updated: February 2026
Terraform Version: 1.0+

---

## Quick Command Reference

```bash
# Initialize working directory
terraform init

# Validate configuration
terraform validate

# Format Terraform files
terraform fmt -recursive

# Create execution plan
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy

# Show current state
terraform show

# List resources in state
terraform state list

# Output values
terraform output

# Workspace management
terraform workspace list
terraform workspace new [workspace]
terraform workspace select [workspace]

# Advanced debugging
TF_LOG=DEBUG terraform plan
TF_LOG_PATH=terraform.log terraform apply
```

## Next Steps

1. Install Terraform if not already done
2. Configure your cloud provider credentials
3. Start with [Day 1: Terraform Basics and Setup](day-01-terraform-basics-and-setup/README.md)
4. Follow the learning path sequentially
5. Complete all exercises
6. Build the capstone project

Good luck with your Terraform learning journey!
