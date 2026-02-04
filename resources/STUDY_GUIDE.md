# Terraform 30-Day Course - Study Guide and Resources

## Course Overview

This document serves as a comprehensive guide to the 30-day Terraform learning journey. It includes study tips, resource links, quick reference guides, and assessment criteria.

## Learning Framework

### Weekly Progress

Week 1 (Days 1-5): Foundation Concepts
- Focus: Core concepts, basic syntax, simple configurations
- Goal: Comfortable with init, plan, apply workflow
- Checkpoint: Deploy a simple EC2 instance

Week 2 (Days 6-10): Advanced Concepts
- Focus: State management, modules, loops, conditionals
- Goal: Write reusable, modular code
- Checkpoint: Build multi-environment configuration

Week 3 (Days 11-22): Cloud Providers
- Focus: AWS, GCP, Azure practical implementation
- Goal: Deploy complete applications
- Checkpoint: Multi-tier application running

Week 4 (Days 23-30): Enterprise Features
- Focus: Testing, CI/CD, best practices, capstone
- Goal: Production-ready infrastructure
- Checkpoint: Complete capstone project

## Study Strategies

### Daily Routine

Each day should take approximately 3-4 hours:

1. Morning (30 min): Read the README.md
2. Mid-day (90 min): Study code examples
3. Afternoon (60 min): Complete lab exercises
4. Evening (30 min): Review and reflect

### Active Learning

1. Read the documentation
2. Study the code
3. Type the code (don't copy-paste)
4. Modify examples
5. Run and test
6. Fix errors
7. Document what you learned

### Practice Patterns

For each day:

1. Read overview
2. Understand concepts
3. Review examples
4. Create similar example
5. Modify and experiment
6. Document in notes
7. Move to next day

## Quick Reference Guides

### Terraform CLI Commands

```bash
# Initialization and setup
terraform init                  # Initialize working directory
terraform validate              # Check syntax
terraform fmt                   # Format files
terraform fmt -check           # Check formatting without changing

# Planning and execution
terraform plan                  # Create execution plan
terraform plan -out=plan.tfplan # Save plan
terraform show plan.tfplan      # Show plan details
terraform apply                 # Apply changes
terraform apply plan.tfplan     # Apply saved plan
terraform destroy               # Destroy infrastructure

# State management
terraform state list            # List resources
terraform state show RESOURCE   # Show resource details
terraform state mv OLD NEW      # Rename resource
terraform state rm RESOURCE     # Remove resource

# Workspace management
terraform workspace list        # List workspaces
terraform workspace new NAME    # Create workspace
terraform workspace select NAME # Switch workspace

# Debugging
terraform graph                 # Display dependency graph
terraform output               # Show outputs
terraform output NAME          # Show specific output
```

### HCL Syntax Quick Reference

```hcl
# Variables
variable "name" {
  type        = string
  default     = "value"
  description = "Description"
}

# Locals
locals {
  name = "value"
}

# Resources
resource "provider_type" "name" {
  argument = value
}

# Modules
module "name" {
  source = "./path"
  variable = value
}

# Outputs
output "name" {
  value = resource.id
}

# Data sources
data "provider_resource" "name" {
  filter = "value"
}

# Conditions
condition ? true_value : false_value

# Loops
for_each = variable
count = variable
for item in list : item.property
```

### Common Functions

```hcl
# String functions
upper(), lower(), trim(), replace(), split(), join()

# List functions
concat(), contains(), flatten(), reverse(), distinct()

# Map functions
keys(), values(), lookup(), merge()

# Numeric functions
min(), max(), ceil(), floor()

# Type functions
type(), length(), tonumber(), tostring()
```

## Resource Library

### Official Documentation

- [Terraform Language Documentation](https://www.terraform.io/language)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

### Learning Resources

- [HashiCorp Learn](https://learn.hashicorp.com/terraform)
- [Terraform by Example](https://www.terraformbyexample.com/)
- [A Comprehensive Guide to Terraform](https://blog.gruntwork.io/)

### Community

- [Terraform Community Forum](https://discuss.hashicorp.com/c/terraform/24)
- [Stack Overflow - Terraform Tag](https://stackoverflow.com/questions/tagged/terraform)
- [GitHub Issues](https://github.com/hashicorp/terraform/issues)

### Tools

- [Terratest](https://github.com/gruntwork-io/terratest) - Testing
- [Tflint](https://github.com/terraform-linters/tflint) - Linting
- [Checkov](https://www.checkov.io/) - Security scanning
- [Infracost](https://www.infracost.io/) - Cost estimation

## Assessment and Checkpoints

### Daily Assessment

For each day, you should be able to:

- Day 1: Explain Terraform workflow, install and configure
- Day 2: Configure multiple providers and authenticate
- Day 3: Create variables with validation and outputs
- Day 4: Query data sources and use locals
- Day 5: Create and manage resources
- Day 6: Understand state and implement remote state
- Day 7: Create and use modules
- Day 8: Compose modules into complex configurations
- Day 9: Use functions and expressions
- Day 10: Implement loops and conditionals
- Day 11: Deploy EC2 instances with advanced features
- Day 12: Design VPCs with high availability
- Day 13: Deploy production RDS databases
- Day 14: Manage S3 buckets securely
- Day 15: Implement IAM policies and roles
- Day 16-18: Deploy complete multi-tier application
- Day 19: Configure GCP provider and resources
- Day 20: Deploy Compute Engine and Cloud SQL
- Day 21: Configure Azure provider
- Day 22: Deploy Azure resources
- Day 23: Implement remote state backend
- Day 24: Test and validate configurations
- Day 25: Manage multiple environments
- Day 26: Set up CI/CD pipeline
- Day 27: Debug and troubleshoot issues
- Day 28: Follow best practices
- Day 29: Implement real-world scenarios
- Day 30: Complete capstone project

### Weekly Milestones

Week 1 Checkpoint:
- Can run terraform init, plan, apply
- Understand state files
- Deploy simple infrastructure

Week 2 Checkpoint:
- Created and used modules
- Implemented loops and conditionals
- Managed multiple environments

Week 3 Checkpoint:
- Deployed resources on AWS, GCP, Azure
- Multi-region deployment working
- Complex configurations understood

Week 4 Checkpoint:
- CI/CD pipeline operational
- Capstone project deployed
- Production-ready code standards met

## Common Mistakes to Avoid

1. Not using .gitignore (commits sensitive data)
2. Hardcoding values (reduces reusability)
3. Skipping validation before apply
4. Not reviewing plans carefully
5. Using terraform.tfstate in version control
6. Not tagging resources
7. Ignoring error messages
8. Not documenting complex logic
9. Not testing before production
10. Insufficient separation of concerns

## Best Practices Summary

### Code Organization

- Separate concerns into files (main.tf, variables.tf, outputs.tf)
- Use modules for reusable components
- Maintain consistent naming conventions
- Document complex logic with comments

### Security

- Never commit secrets or credentials
- Use variables with sensitive flag
- Implement least privilege IAM
- Enable encryption at rest and in transit
- Regular security scanning

### State Management

- Always use remote state
- Enable state locking
- Encrypt state at rest
- Backup state regularly
- Limit access to state files

### Testing and Validation

- Run terraform validate
- Use terraform fmt
- Implement automated testing
- Review plans before applying
- Test in non-production first

### Documentation

- Every module needs README
- Every variable needs description
- Complex resources need comments
- Maintain architecture diagrams
- Keep runbooks updated

## Exam/Assessment Preparation

### Topics to Master

1. Terraform fundamentals and workflow
2. Configuration language (HCL)
3. Providers and authentication
4. Resources, data sources, and outputs
5. Variables, locals, and conditionals
6. Modules and composition
7. State management and backends
8. Functions and expressions
9. Loops and iteration
10. Cloud provider specific knowledge
11. Testing and security
12. CI/CD integration
13. Troubleshooting and debugging
14. Best practices and patterns

### Practice Exercises

For each topic:
1. Implement from scratch
2. Modify existing code
3. Fix broken configurations
4. Optimize for performance
5. Improve security posture

### Sample Questions

1. How do you protect sensitive data in state files?
2. When should you use count vs for_each?
3. What is the difference between local and remote state?
4. How do you structure a large Terraform project?
5. What are the benefits of using modules?
6. How do you test Terraform configurations?
7. What is a data source and when would you use one?
8. How do you implement blue-green deployments?
9. What are the security best practices?
10. How do you handle multiple environments?

## Troubleshooting Guide

### Quick Fixes

| Issue | Solution |
|-------|----------|
| Command not found | Add Terraform to PATH |
| Provider not found | Run terraform init |
| Credentials error | Configure AWS/GCP/Azure credentials |
| State lock error | Check for concurrent operations |
| Variable validation error | Review variable types and values |
| Resource not found | Check resource exists in cloud provider |
| Timeout error | Increase timeout or check logs |
| Type mismatch | Verify variable types match values |

### Debug Workflow

1. Read error message carefully
2. Check terraform logs (TF_LOG=DEBUG)
3. Verify syntax (terraform validate)
4. Review plan output
5. Check state consistency
6. Verify provider credentials
7. Test with simpler configuration
8. Search documentation for error
9. Check GitHub issues
10. Ask community

## Progress Tracking

Create a checklist for each day:

- [ ] Read README.md
- [ ] Understand key concepts
- [ ] Review code examples
- [ ] Complete lab exercises
- [ ] Fix any errors
- [ ] Document learnings
- [ ] Ready for next day

## Reflection and Review

After each week, reflect on:

1. What was difficult?
2. What was easy?
3. What do I need to practice more?
4. How can I apply this to my work?
5. What questions do I still have?

After the entire course, create:

1. Lessons learned document
2. Practice projects
3. Reference guide for future use
4. Portfolio piece for your resume
5. Knowledge base for your team

## Next Steps After Course

1. Apply to real projects
2. Join Terraform community
3. Contribute to open source
4. Pursue HashiCorp certifications
5. Build and share modules
6. Mentor others
7. Stay updated with releases
8. Explore advanced topics

## Certification Path

### Terraform Associate

Topics:
- Terraform fundamentals
- Configuration syntax
- State management
- Modules
- Debugging

Resources:
- [Exam Guide](https://www.hashicorp.com/certification/terraform-associate)
- [Study Materials](https://learn.hashicorp.com/collections/terraform/certification-associate-review)

### Professional Certifications

After Associate:
- Terraform Professional
- Cloud provider certifications
- Advanced architecture

## Continuous Learning

Stay updated with:
- [Terraform Blog](https://www.hashicorp.com/blog)
- [Terraform GitHub Releases](https://github.com/hashicorp/terraform/releases)
- [Provider Documentation](https://registry.terraform.io/)
- [Community Forums](https://discuss.hashicorp.com/)

---

Last Updated: February 2026
Course Version: 1.0
Terraform Version: 1.0+
