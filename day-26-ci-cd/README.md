````markdown
# Day 26: CI/CD Integration

Integrate Terraform into CI/CD pipelines for automated infrastructure deployment.

## Key Topics

1. GitHub Actions
2. GitLab CI
3. Pipeline Stages
4. Automated Plan and Apply
5. Approval Workflows

## GitHub Actions Workflow

```yaml
name: Terraform CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  AWS_REGION: us-east-1
  TF_VERSION: 1.5.0

jobs:
  terraform:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: ${{ env.TF_VERSION }}

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}

    - name: Terraform Init
      run: terraform init

    - name: Terraform Format Check
      run: terraform fmt -check -recursive

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan -out=tfplan
      continue-on-error: true

    - name: Save Plan
      uses: actions/upload-artifact@v3
      with:
        name: tfplan
        path: tfplan

  apply:
    needs: terraform
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'

    steps:
    - uses: actions/checkout@v3

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v2
      with:
        terraform_version: ${{ env.TF_VERSION }}

    - name: Configure AWS credentials
      uses: aws-actions/configure-aws-credentials@v2
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ env.AWS_REGION }}

    - name: Terraform Init
      run: terraform init

    - name: Download Plan
      uses: actions/download-artifact@v3
      with:
        name: tfplan

    - name: Terraform Apply
      run: terraform apply -auto-approve tfplan
```

## GitLab CI Pipeline

```yaml
stages:
  - validate
  - plan
  - apply
  - destroy

variables:
  TF_VERSION: "1.5.0"
  AWS_DEFAULT_REGION: "us-east-1"

before_script:
  - terraform --version

terraform_validate:
  stage: validate
  script:
    - terraform init
    - terraform validate
    - terraform fmt -check -recursive

terraform_plan:
  stage: plan
  script:
    - terraform init
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - tfplan
    expire_in: 1 day

terraform_apply:
  stage: apply
  script:
    - terraform init
    - terraform apply -auto-approve tfplan
  only:
    - main
  when: manual

terraform_destroy:
  stage: destroy
  script:
    - terraform init
    - terraform destroy -auto-approve
  only:
    - main
  when: manual
```

## Secrets Management

GitHub Actions:

```bash
# Add secrets in GitHub repository settings
# Then use in workflow:
${{ secrets.AWS_ACCESS_KEY_ID }}
${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

GitLab CI:

```bash
# Add variables in GitLab project settings
# Then use in pipeline:
$AWS_ACCESS_KEY_ID
$AWS_SECRET_ACCESS_KEY
```

## Approval Workflow

```yaml
terraform_apply:
  stage: apply
  environment:
    name: production
  script:
    - terraform apply -auto-approve tfplan
  only:
    - main
  when: manual  # Requires manual approval
```

## Lab: Set Up GitHub Actions

1. Create GitHub repository
2. Create GitHub Actions workflow file
3. Add AWS credentials as secrets
4. Push Terraform code to trigger pipeline
5. Verify plan output
6. Manually approve apply step

---

Estimated Time: 3-4 hours

````
