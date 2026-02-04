# Terraform 30-Day Course - Complete Index
# Khoa hoc Terraform 30 ngay - Chi muc Hoan chinh

This index provides a complete overview of all course materials.
Chi muc nay cung cap tong quan hoan chinh ve tat ca cac tai lieu khoa hoc.

## Main Documentation / Tai lieu Chinh

1. **README.md** - Course overview and structure
   - Introduction to the 30-day course
   - Course objectives
   - How to use the materials
   - Prerequisites

2. **QUICK_START.md** - Quick start guide
   - Getting started immediately
   - Directory structure
   - How to use each day
   - Daily schedule
   - Common commands

3. **LEARNING_PATH.md** - Detailed learning path
   - Week-by-week progression
   - Day-by-day breakdown
   - Learning outcomes
   - Post-course directions

4. **COMMANDS_REFERENCE.md** - Command reference
   - Complete command listing
   - Usage examples (bilingual)
   - Tips and best practices
   - Common combinations

## Week 1: Fundamentals / Tuan 1: Co ban

### Day 1: Introduction and Installation
**Location**: day-01/
**Duration**: 2 hours
**Topics**:
- What is Terraform
- Infrastructure as Code
- Installation steps
- Verification

**Files**:
- day-01/README.md - Full day 1 content
- day-01/example.tf - Basic example structure

### Day 2: Terraform Basics and HCL Syntax
**Location**: day-02/
**Duration**: 2 hours
**Topics**:
- HCL syntax fundamentals
- Block structure
- Comments
- Data types
- Your first configuration

**Files**:
- day-02/README.md - Full day 2 content
- day-02/main.tf - Working example code
- day-02/lab-2.1-first-config/instructions.md - Lab exercise

### Day 3: Providers and Configuration
**Location**: day-03/
**Duration**: 2 hours
**Topics**:
- Understanding providers
- Provider configuration
- Multiple providers
- Provider aliases
- Versioning

**Files**:
- day-03/README.md - Full day 3 content
- day-03/main.tf - Multiple provider examples

### Day 4: Resources and Resource Blocks
**Location**: day-04/
**Duration**: 2 hours
**Topics**:
- Resource syntax
- Meta-arguments (depends_on, count, for_each)
- Resource addressing
- Lifecycle management

**Files**:
- day-04/README.md - Full day 4 content
- day-04/main.tf - Resource examples with meta-arguments

### Day 5: Terraform State Basics
**Location**: day-05/
**Duration**: 2 hours
**Topics**:
- State file purpose
- State commands
- State locking
- State best practices

**Files**:
- day-05/README.md - Full day 5 content
- day-05/main.tf - State management example

### Day 6: Terraform Commands and Workflow
**Location**: day-06/
**Duration**: 2 hours
**Topics**:
- Essential commands
- Workflow process
- Debugging techniques
- Best practices

**Files**:
- day-06/README.md - Full day 6 content
- day-06/main.tf - Workflow demonstration

### Day 7: Week 1 Review and Practice
**Location**: day-07/
**Duration**: 2 hours
**Topics**:
- Week 1 recap
- Comprehensive review
- Practice project
- Self-assessment

**Files**:
- day-07/README.md - Review material and assessment

## Week 2: Working with Resources and State / Tuan 2: Lam viec voi Tai nguyen va Trang thai

### Day 8: Input Variables
**Location**: day-08/
**Duration**: 2 hours
**Topics**:
- Variable declaration
- Variable types
- Validation rules
- Setting values

**Files**:
- day-08/README.md - Full day 8 content
- day-08/main.tf - Variable examples
- day-08/terraform.tfvars - Sample variables

### Day 9: Output Values
**Location**: day-09/
**Duration**: 2 hours
**Topics**:
- Output declaration
- Output types
- Sensitive outputs
- Querying outputs

**Files**:
- day-09/README.md - Full day 9 content
- day-09/main.tf - Output examples

### Day 10: Local Values and Data Sources
**Location**: day-10/
**Duration**: 2 hours
**Topics**:
- Local values
- Data sources
- DRY principle
- Combining features

**Files**:
- day-10/README.md - Full day 10 content
- day-10/main.tf - Locals and data sources

### Day 11: Advanced State Management
**Location**: day-11/
**Duration**: 2 hours
**Topics**:
- State file structure
- State commands
- Recovery procedures
- Troubleshooting

**Files**:
- day-11/README.md - Full day 11 content
- day-11/main.tf - State management examples
- day-11/state-commands.txt - Command reference

### Day 12: Remote State and Backends
**Location**: day-12/
**Duration**: 2 hours
**Topics**:
- Backend types
- Configuration
- State locking
- Migration

**Files**:
- day-12/README.md - Full day 12 content
- day-12/backend-examples.tf - Backend configurations

### Day 13: Resource Dependencies
**Location**: day-13/
**Duration**: 2 hours
**Topics**:
- Implicit dependencies
- Explicit dependencies
- Dependency graphs
- Complex scenarios

**Files**:
- day-13/README.md - Full day 13 content
- day-13/main.tf - Dependency examples

### Day 14: Week 2 Review and Practice
**Location**: day-14/
**Duration**: 2 hours
**Topics**:
- Week 2 recap
- Integration review
- Practice project
- Assessment

**Files**:
- day-14/README.md - Review material

## Week 3: Modules and Advanced Features / Tuan 3: Modules va Tinh nang Nang cao

### Day 15: Introduction to Modules
**Location**: day-15/
**Duration**: 2 hours
**Topics**:
- Module concept
- Module structure
- Creating modules
- Using modules

**Files**:
- day-15/README.md - Full day 15 content
- day-15/modules/web-server/ - Example module
  - day-15/modules/web-server/main.tf
  - day-15/modules/web-server/variables.tf
  - day-15/modules/web-server/outputs.tf
- day-15/main.tf - Using modules

### Day 16: Creating Custom Modules
**Location**: day-16/
**Duration**: 2 hours
**Topics**:
- Module design
- Best practices
- Versioning
- Testing

**Files**:
- day-16/README.md - Full day 16 content

### Day 17: Module Registry and Public Modules
**Location**: day-17/
**Duration**: 2 hours
**Topics**:
- Terraform Registry
- Using modules
- Publishing
- Community

**Files**:
- day-17/README.md - Full day 17 content

### Day 18: Workspaces
**Location**: day-18/
**Duration**: 2 hours
**Topics**:
- Workspace basics
- Commands
- Multiple environments
- Limitations

**Files**:
- day-18/README.md - Full day 18 content
- day-18/main.tf - Workspace examples

### Day 19: Functions and Expressions
**Location**: day-19/
**Duration**: 2 hours
**Topics**:
- String functions
- Collection functions
- Numeric functions
- Function composition

**Files**:
- day-19/README.md - Full day 19 content
- day-19/main.tf - Function examples

### Day 20: Conditional Expressions and Loops
**Location**: day-20/
**Duration**: 2 hours
**Topics**:
- Conditionals
- For expressions
- Count and for_each
- Dynamic blocks

**Files**:
- day-20/README.md - Full day 20 content
- day-20/main.tf - Loop and conditional examples

### Day 21: Week 3 Review and Practice
**Location**: day-21/
**Duration**: 2 hours
**Topics**:
- Week 3 recap
- Module review
- Complex configurations
- Assessment

**Files**:
- day-21/README.md - Review material

## Week 4: Production and Best Practices / Tuan 4: San xuat va Thuc hanh Tot nhat

### Day 22: Terraform Best Practices
**Location**: day-22/
**Duration**: 2 hours
**Topics**:
- Code organization
- Naming conventions
- Documentation
- Version control
- State protection

**Files**:
- day-22/README.md - Full day 22 content

### Day 23: Security and Secrets Management
**Location**: day-23/
**Duration**: 2 hours
**Topics**:
- Sensitive data
- Secret management
- Encryption
- Access control

**Files**:
- day-23/README.md - Full day 23 content
- day-23/main.tf - Security examples

### Day 24: Testing Terraform Code
**Location**: day-24/
**Duration**: 2 hours
**Topics**:
- Validation
- Testing strategies
- Tools and automation
- Quality assurance

**Files**:
- day-24/README.md - Full day 24 content

### Day 25: CI/CD with Terraform
**Location**: day-25/
**Duration**: 2 hours
**Topics**:
- CI/CD integration
- Pipeline design
- Automation platforms
- Deployment workflows

**Files**:
- day-25/README.md - Full day 25 content

### Day 26: Multi-Cloud Strategies
**Location**: day-26/
**Duration**: 2 hours
**Topics**:
- Multi-cloud design
- Provider selection
- Cloud-agnostic approaches
- Complexity management

**Files**:
- day-26/README.md - Full day 26 content

### Day 27: Real-World Project Part 1 - Planning
**Location**: day-27/
**Duration**: 2 hours
**Topics**:
- Project architecture
- Requirements analysis
- Component breakdown
- Planning

**Files**:
- day-27/README.md - Full day 27 content

### Day 28: Real-World Project Part 2 - Implementation
**Location**: day-28/
**Duration**: 2 hours
**Topics**:
- Infrastructure implementation
- Network setup
- Compute resources
- Databases and storage

**Files**:
- day-28/README.md - Full day 28 content

### Day 29: Real-World Project Part 3 - Deployment
**Location**: day-29/
**Duration**: 2 hours
**Topics**:
- Deployment strategy
- Execution
- Validation
- Troubleshooting

**Files**:
- day-29/README.md - Full day 29 content

### Day 30: Course Review and Next Steps
**Location**: day-30/
**Duration**: 2 hours
**Topics**:
- Complete review
- Skills assessment
- Certification path
- Continuous learning

**Files**:
- day-30/README.md - Final review material

## How to Use This Index / Cach Su dung Chi muc nay

1. **Start with README.md** - Get overall understanding
   Bat dau voi README.md - Hieu tong quat

2. **Read QUICK_START.md** - Immediate getting started
   Doc QUICK_START.md - Bat dau ngay lap tuc

3. **Follow LEARNING_PATH.md** - Day-by-day progression
   Lam theo LEARNING_PATH.md - Tien trinh theo ngay

4. **Reference COMMANDS_REFERENCE.md** - While working
   Tham khao COMMANDS_REFERENCE.md - Trong khi lam viec

5. **Use this index** - To navigate the course
   Su dung chi muc nay - De huong dan khoa hoc

## Search by Topic / Tim kiem theo Chu de

### Variables and Configuration
- Day 8: Input Variables (day-08/)
- Day 2: HCL Syntax (day-02/)
- Day 12: Backends (day-12/)

### Infrastructure Management
- Day 4: Resources (day-04/)
- Day 13: Dependencies (day-13/)
- Day 27-29: Real Projects (day-27-29/)

### Code Quality and Testing
- Day 22: Best Practices (day-22/)
- Day 23: Security (day-23/)
- Day 24: Testing (day-24/)

### Reusability and Modules
- Day 15: Modules Intro (day-15/)
- Day 16: Custom Modules (day-16/)
- Day 17: Registry (day-17/)

### Advanced Features
- Day 18: Workspaces (day-18/)
- Day 19: Functions (day-19/)
- Day 20: Loops/Conditionals (day-20/)

### State Management
- Day 5: State Basics (day-05/)
- Day 11: Advanced State (day-11/)
- Day 12: Remote State (day-12/)

## Language Notes / Ghi chu Ngon ngu

All materials are bilingual:
- English content on the left
- Vietnamese content on the right / Noi dung Tieng Viet ben phai

No emojis or icons are used:
- Pure text formatting
- Clean and professional
- Khong su dung emoji hoac icon

All code comments are in both languages:
- Each comment explained twice
- Easy to understand concepts
- Tung chu thich duoc giai thich hai lan

## Time Management / Quan ly Thoi gian

- Each day: approximately 2 hours
- Per week: 14 hours (including review)
- Total course: 60 hours
- Flexible schedule possible

Moi ngay: khoang 2 gio
Tuan: 14 gio (bao gom on tap)
Tong khoa hoc: 60 gio
Lich trinh linh hoat co the

## Next Steps After Completion / Buoc tiep theo sau hoan thanh

1. Review difficult topics
2. Build personal projects
3. Study cloud-specific providers
4. Pursue certification
5. Join community
6. Contribute to open source

Xem xet cac chu de kho
Xay dung du an ca nhan
Hoc cac provider cu the cua dam may
Theo sau chung chi
Tham gia cong dong
Dong gop cho open source

---

This comprehensive course prepares you for:
- Real-world Terraform usage
- Team collaboration
- Production deployments
- Certification exams
- Continuous infrastructure management

Khoa hoc nay chuan bi ban cho:
- Su dung Terraform thuc te
- Cong tac nhom
- Trien khai san xuat
- Ky thi chung chi
- Quan ly ha tang lien tuc
