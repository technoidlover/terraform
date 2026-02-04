# Day 2: Provider Configuration

## Learning Objectives

By the end of this day, you will understand:

1. What providers are in Terraform
2. How to configure different providers
3. AWS provider configuration options
4. Alternative authentication methods
5. Provider versioning strategies
6. Multi-region deployments
7. Provider aliases and multiple instances

## Topics Covered

1. Introduction to Providers
2. AWS Provider Configuration
3. Authentication Methods
4. Provider Versioning
5. Multiple Providers
6. Provider Aliases
7. Provider Configuration Best Practices

## 1. What Are Providers?

Providers are Terraform plugins that allow interaction with APIs of cloud platforms and other services.

Key concepts:

- Providers are plugins that translate Terraform code to API calls
- Each provider manages specific cloud or service resources
- Providers handle authentication and API communication
- Different providers support different resource types
- Providers are versioned and can be updated independently

### Popular Providers

- **AWS**: amazon-web-services
- **Azure**: microsoft-azure
- **GCP**: google-cloud
- **Kubernetes**: kubernetes
- **Docker**: docker
- **GitHub**: github
- **Datadog**: datadog
- **Vault**: hashicorp-vault

## 2. AWS Provider Configuration

### Basic Configuration

```hcl
provider "aws" {
  region = "us-east-1"
}
```

### Advanced Configuration

```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAIOSFODNN7EXAMPLE"
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

  default_tags {
    tags = {
      Environment = "production"
      Owner       = "terraform"
    }
  }

  skip_region_validation      = false
  skip_credentials_validation = false
  skip_metadata_api_check     = false
}
```

## 3. Authentication Methods

### Method 1: Environment Variables (Recommended for CI/CD)

```bash
# Windows PowerShell
$env:AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
$env:AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
$env:AWS_DEFAULT_REGION = "us-east-1"

# Linux/macOS
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_DEFAULT_REGION="us-east-1"
```

### Method 2: AWS Credentials File (~/.aws/credentials)

```
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[production]
aws_access_key_id = AKIA2IOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY2
```

### Method 3: IAM Role (For EC2 Instances)

```hcl
provider "aws" {
  region = "us-east-1"
  # When running on EC2 with IAM role, credentials are automatically detected
}
```

### Method 4: Assume IAM Role

```hcl
provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::123456789012:role/terraform-role"
    session_name = "terraform-session"
    duration     = "1h"
  }
}
```

## 4. Provider Versioning

### Version Constraint Operators

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.0.0"        # Exact version
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"         # 5.x (compatible)
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"  # Range
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"         # Minimum version
    }
  }
}
```

## 5. Multi-Provider Configuration

### Multiple AWS Regions

```hcl
provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "us-west-2"
  region = "us-west-2"
}

resource "aws_instance" "east" {
  provider      = aws.us-east-1
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_instance" "west" {
  provider      = aws.us-west-2
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

### Multiple Different Providers

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = aws_eks_cluster.main.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.main.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.main.token
}
```

## 6. Default Tags

### Applying Tags to All Resources

```hcl
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "Terraform30Days"
      Environment = "production"
      Owner       = "platform-team"
      ManagedBy   = "terraform"
      CostCenter  = "engineering"
    }
  }
}

# Resources inherit default tags automatically
resource "aws_instance" "example" {
  # ... configuration ...
  tags = {
    Name = "web-server"  # This will be merged with default tags
  }
}
```

## Lab Exercise: Multi-Region AWS Setup

Create a configuration that deploys resources to multiple AWS regions.

### Files to Create

#### main.tf

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

# Primary region provider
provider "aws" {
  alias  = "primary"
  region = var.primary_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "MultiRegion"
    }
  }
}

# Secondary region provider
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = "MultiRegion"
    }
  }
}

# S3 bucket in primary region
resource "aws_s3_bucket" "primary" {
  provider = aws.primary
  bucket   = "my-bucket-primary-${data.aws_caller_identity.primary.account_id}"

  tags = {
    Region = var.primary_region
  }
}

# S3 bucket in secondary region
resource "aws_s3_bucket" "secondary" {
  provider = aws.secondary
  bucket   = "my-bucket-secondary-${data.aws_caller_identity.secondary.account_id}"

  tags = {
    Region = var.secondary_region
  }
}

# Data sources for account ID
data "aws_caller_identity" "primary" {
  provider = aws.primary
}

data "aws_caller_identity" "secondary" {
  provider = aws.secondary
}
```

#### variables.tf

```hcl
variable "primary_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "development"
}
```

#### outputs.tf

```hcl
output "primary_bucket" {
  description = "Primary region bucket name"
  value       = aws_s3_bucket.primary.id
}

output "secondary_bucket" {
  description = "Secondary region bucket name"
  value       = aws_s3_bucket.secondary.id
}

output "primary_region" {
  value = var.primary_region
}

output "secondary_region" {
  value = var.secondary_region
}
```

## Best Practices

1. Always specify required provider versions
2. Use environment variables for sensitive credentials
3. Never commit credentials to version control
4. Use IAM roles when running on AWS
5. Apply default tags for consistent tagging
6. Document provider configuration requirements
7. Use provider aliases for multi-region deployments
8. Lock provider versions for consistency

## Exercises

### Exercise 1: Configure AWS Provider

1. Create a new directory for this lab
2. Set up AWS credentials (use aws configure)
3. Create a basic provider block
4. Run terraform init

### Exercise 2: Add Default Tags

1. Add default_tags block to provider
2. Create a simple S3 bucket resource
3. Verify tags are applied in AWS console

### Exercise 3: Multi-Region Setup

1. Follow the lab exercise above
2. Deploy to two regions
3. Verify resources in both regions

## Next Steps

1. Complete all exercises
2. Verify AWS credentials work
3. Proceed to Day 3

---

Estimated Time: 2-3 hours
