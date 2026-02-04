# Day 3: Providers and Provider Configuration
# Ngay 3: Providers va Cau hinh Provider

## Objectives / Muc tieu

By the end of this day, you will:
- Understand what Terraform providers are
- Learn how to configure providers
- Work with multiple providers
- Use provider aliases
- Understand provider versioning

Vao cuoi ngay nay, ban se:
- Hieu providers Terraform la gi
- Hoc cach cau hinh providers
- Lam viec voi nhieu providers
- Su dung alias provider
- Hieu ve phien ban provider

## What are Providers? / Providers la gi?

Providers are plugins that enable Terraform to interact with cloud platforms, SaaS providers, and other APIs.

Providers la cac plugin cho phep Terraform tuong tac voi cac nen tang dam may, nha cung cap SaaS va cac API khac.

### Popular Providers / Cac Provider Pho bien

- AWS (Amazon Web Services)
- Azure (Microsoft Azure)
- GCP (Google Cloud Platform)
- Kubernetes
- Docker
- GitHub
- Local (for local resources)

## Provider Configuration / Cau hinh Provider

Basic provider configuration:
Cau hinh provider co ban:

```hcl
provider "provider_name" {
  region = "us-east-1"
  # Other provider-specific settings
  # Cac cai dat cu the khac cua provider
}
```

## Provider Versioning / Phien ban Provider

Always specify provider versions for consistency:
Luon chi dinh phien ban provider de nhat quan:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Allows 5.x but not 6.0
    }
  }
}
```

### Version Constraints / Rang buoc Phien ban

- `=`: Exact version
- `!=`: Exclude version
- `>`, `>=`, `<`, `<=`: Comparison operators
- `~>`: Allows rightmost version component to increment

- `=`: Phien ban chinh xac
- `!=`: Loai tru phien ban
- `>`, `>=`, `<`, `<=`: Toan tu so sanh
- `~>`: Cho phep thanh phan phien ban ngoai cung tang

## Multiple Providers / Nhieu Providers

You can use multiple providers in one configuration:
Ban co the su dung nhieu providers trong mot cau hinh:

```hcl
provider "aws" {
  region = "us-east-1"
}

provider "local" {
  # Local provider configuration
}
```

## Provider Aliases / Ban sao Provider

Use aliases to configure the same provider multiple times:
Su dung alias de cau hinh cung mot provider nhieu lan:

```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

provider "aws" {
  region = "us-west-2"
  alias  = "west"
}

resource "aws_instance" "example" {
  provider = aws.west
  # Resource configuration
}
```

## Provider Authentication / Xac thuc Provider

Different providers have different authentication methods:
Cac provider khac nhau co cac phuong thuc xac thuc khac nhau:

### AWS Example:
```hcl
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
```

### Azure Example:
```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
```

## Key Takeaways / Diem Chinh

- Providers enable Terraform to manage different platforms
- Always specify provider versions
- Use aliases for multiple configurations of same provider
- Keep sensitive credentials in variables or environment
- Provider configuration is required before creating resources

- Providers cho phep Terraform quan ly cac nen tang khac nhau
- Luon chi dinh phien ban provider
- Su dung alias cho nhieu cau hinh cua cung provider
- Giu thong tin nhay cam trong bien hoac bien moi truong
- Cau hinh provider la bat buoc truoc khi tao tai nguyen

## Next Steps / Buoc tiep theo

Tomorrow (Day 4), we will dive deep into Resources.
Ngay mai (Ngay 4), chung ta se tim hieu sau ve Resources.

---

End of Day 3 / Ket thuc Ngay 3
