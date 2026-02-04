# Terraform 30-Day Course - Learning Path
# Khóa Học Terraform 30 Ngày - Đường Dẫn Học Tập

## Course Map / Bản Đồ Khóa Học

This document outlines the complete learning path for the
30-day Terraform course.

Tài liệu này trình bày đường dẫn học tập đầy đủ cho
khóa học Terraform 30 ngày.

## Week 1: Fundamentals / Tuần 1: Cơ Bản

Essential foundation for all Terraform work.

Nền tảng cần thiết cho tất cả công việc Terraform.

### Day 1: Introduction and Installation
- What is Terraform
- Infrastructure as Code concepts
- Installation on Windows, macOS, Linux
- Verification of installation
- Basic command overview

**Outputs**: Terraform installed and verified

### Day 2: Terraform Basics and HCL Syntax
- HCL language fundamentals
- Block syntax and structure
- Comments and formatting
- Data types
- First configuration

**Outputs**: First working Terraform configuration

### Day 3: Providers and Configuration
- Provider concept
- Provider authentication
- Multiple providers
- Provider aliases
- Version constraints

**Outputs**: Configuration using multiple providers

### Day 4: Resources and Resource Blocks
- Resource syntax
- Meta-arguments (depends_on, count, for_each)
- Resource addressing
- Lifecycle management
- Resource dependencies

**Outputs**: Configuration with various resource types

### Day 5: Terraform State Basics
- What is state
- State file structure
- State commands
- State best practices
- Local vs remote state

**Outputs**: Understanding state management

### Day 6: Terraform Commands and Workflow
- Essential commands (init, plan, apply, destroy)
- Command options and flags
- Workflow automation
- Debugging commands
- Output interpretation

**Outputs**: Mastery of Terraform commands

### Day 7: Week 1 Review and Practice
- Review all week 1 concepts
- Practice project
- Skills assessment
- Preparation for week 2

**Outputs**: Complete understanding of fundamentals

## Week 2: Working with State and Resources / Tuần 2: Làm Việc Với Trạng Thái Và Tài Nguyên

Advanced concepts for managing infrastructure.

Khái niệm nâng cao cho quản lý hạ tầng.

### Day 8: Input Variables
- Variable declaration
- Variable types
- Default values
- Variable validation
- Setting variable values (CLI, files, environment)

**Outputs**: Reusable configurations with variables

### Day 9: Output Values
- Output declaration
- Output usage
- Sensitive outputs
- Querying outputs
- Outputs in modules

**Outputs**: Exposing infrastructure information

### Day 10: Local Values and Data Sources
- Local value usage
- Data source concept
- Querying existing resources
- DRY principle
- Combining with other features

**Outputs**: Reduced code repetition

### Day 11: Advanced State Management
- State file structure
- State commands (list, show, mv, rm)
- State recovery procedures
- State conflicts
- Troubleshooting state issues

**Outputs**: Safe state manipulation

### Day 12: Remote State and Backends
- Backend types
- S3 backend configuration
- State locking mechanisms
- State encryption
- Migration to remote state

**Outputs**: Team-friendly state management

### Day 13: Resource Dependencies
- Implicit dependencies
- Explicit dependencies (depends_on)
- Dependency graph visualization
- Complex dependency scenarios
- Optimization

**Outputs**: Correct resource ordering

### Day 14: Week 2 Review and Practice
- Review all week 2 concepts
- Comprehensive practice project
- State management exercises
- Preparation for week 3

**Outputs**: Advanced Terraform skills

## Week 3: Modules and Advanced Features / Tuan 3: Modules va Tinh nang Nang cao

Code reusability and advanced programming.

Tai su dung ma va lap trinh nang cao.

### Day 15: Introduction to Modules
- Module concept and benefits
- Module structure
- Module sources
- Calling modules
- Input and output

**Outputs**: First reusable module

### Day 16: Creating Custom Modules
- Module design principles
- Module best practices
- Versioning modules
- Module documentation
- Testing modules

**Outputs**: Well-designed custom module

### Day 17: Module Registry and Public Modules
- Terraform Registry overview
- Using public modules
- Module quality assessment
- Publishing modules
- Community contribution

**Outputs**: Using production-ready modules

### Day 18: Workspaces
- Workspace concept
- Workspace commands
- Multiple environment management
- Workspace limitations
- Alternatives to workspaces

**Outputs**: Environment-specific configurations

### Day 19: Functions and Expressions
- String functions (upper, lower, replace, etc.)
- Collection functions (length, merge, keys, etc.)
- Numeric functions (min, max, ceil, floor, etc.)
- Type conversion functions
- Function composition

**Outputs**: Dynamic configuration values

### Day 20: Conditional Expressions and Loops
- Ternary conditional operator
- For expressions (list and map comprehension)
- Count meta-argument
- For_each meta-argument
- Dynamic blocks

**Outputs**: Flexible and scalable configurations

### Day 21: Week 3 Review and Practice
- Review all week 3 concepts
- Complex module project
- Advanced feature integration
- Preparation for week 4

**Outputs**: Mastery of modules and advanced features

## Week 4: Production and Best Practices / Tuan 4: San xuat va Thuc hanh Tot nhat

Real-world practices and production readiness.

Cac thuc hanh thuc te va san sang san xuat.

### Day 22: Terraform Best Practices
- Code organization
- Naming conventions
- Documentation standards
- Version control usage
- State file protection
- Team collaboration

**Outputs**: Professional code structure

### Day 23: Security and Secrets Management
- Sensitive variable marking
- Secret storage (Vault, KMS)
- Credential management
- Access control (IAM)
- Encryption strategies
- Audit logging

**Outputs**: Secure infrastructure code

### Day 24: Testing Terraform Code
- Syntax validation
- Linting (tflint)
- Plan review techniques
- Integration testing
- Automated testing
- Continuous validation

**Outputs**: Tested and validated code

### Day 25: CI/CD with Terraform
- CI/CD pipeline design
- Automation platforms (GitHub Actions, GitLab CI, Jenkins)
- Approval workflows
- Automated deployment
- Rollback procedures
- Monitoring integration

**Outputs**: Automated deployment pipeline

### Day 26: Multi-Cloud Strategies
- Multi-cloud architecture
- Provider selection
- Cloud-agnostic design
- Multi-cloud patterns
- Complexity management
- Cost optimization

**Outputs**: Multi-cloud capable infrastructure

### Day 27: Real-World Project Part 1 - Planning
- Project architecture design
- Requirement analysis
- Component breakdown
- Module planning
- Environment strategy

**Outputs**: Detailed project plan

### Day 28: Real-World Project Part 2 - Implementation
- Network infrastructure
- Compute resources
- Database setup
- Storage configuration
- Monitoring implementation

**Outputs**: Implemented infrastructure

### Day 29: Real-World Project Part 3 - Deployment
- Deployment strategy
- Pre-deployment checklist
- Execution plan
- Post-deployment validation
- Troubleshooting and optimization

**Outputs**: Deployed and verified infrastructure

### Day 30: Course Review and Next Steps
- Complete course review
- Skills assessment
- Certification preparation
- Continuous learning path
- Community involvement

**Outputs**: Course completion and future direction

## Learning Outcomes / Ket qua Hoc tap

### By Day 7 (Week 1)
- Understand Terraform fundamentals
- Write basic configurations
- Execute Terraform workflow
- Manage local state

### By Day 14 (Week 2)
- Use variables and outputs
- Manage state effectively
- Handle dependencies
- Use remote state

### By Day 21 (Week 3)
- Design and use modules
- Use advanced features
- Work with multiple environments
- Write complex configurations

### By Day 30 (Week 4)
- Follow best practices
- Implement security
- Automate deployments
- Manage production infrastructure
- Ready for certification

## Recommended Time Allocation / Phan bo Thoi gian Duy nghi

**Per Day Average**: 2 hours
- Reading: 30 minutes
- Theory study: 30 minutes
- Code review: 30 minutes
- Lab exercises: 30 minutes

**Weekly**: 14 hours (includes review)

**Total Course**: 60 hours (includes projects)

## Success Metrics / Tieu chi Thanh cong

You'll be successful when you can:
- Write Terraform configurations independently
- Design reusable modules
- Manage complex infrastructure
- Handle team collaboration
- Implement security best practices
- Automate deployments
- Troubleshoot issues
- Follow industry standards

## Prerequisites Verification / Xac minh Tien quyet

Before starting, ensure you have:
- System requirements met
- Terraform installed
- Code editor set up
- Git configured
- Cloud account access (optional)
- Basic terminal skills

## Post-Course Path / Duong dan Sau khoa hoc

### Immediate Next Steps
1. Complete all 30 days
2. Build personal project
3. Practice with real cloud
4. Review difficult topics
5. Take practice tests

### Further Learning
1. Cloud-specific training (AWS, Azure, GCP)
2. Advanced Terraform features
3. Terraform Cloud/Enterprise
4. Sentinel policy as code
5. Custom provider development

### Certification
- HashiCorp Certified: Terraform Associate
- Study resources provided
- Practice exams
- Exam registration

### Community Involvement
- Share your projects
- Help others learn
- Contribute to modules
- Attend meetups
- Write documentation

---

This learning path is designed to systematically build your
Terraform expertise from complete beginner to production-ready.

Duong dan hoc tap nay duoc thiet ke de xay dung kien thuc
Terraform cua ban tu nguoi moi bat dau den san sang san xuat.

Follow the path, practice consistently, and you'll master
Terraform within 30 days.

Lam theo duong dan, thuc hanh thuong xuyen, va ban se thong
thao Terraform trong 30 ngay.
