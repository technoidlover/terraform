# Day 27: Troubleshooting and Debugging

Solve common Terraform problems and debug complex configurations.

## Key Topics

1. Common Errors
2. Debugging Techniques
3. Log Analysis
4. State Issues
5. Provider Problems

## Common Errors and Solutions

### Credential Errors

```
Error: error configuring Terraform AWS Provider: no valid credential sources found
```

Solution:

```bash
# Verify credentials
aws configure list

# Set environment variables
set AWS_ACCESS_KEY_ID=your_key
set AWS_SECRET_ACCESS_KEY=your_secret

# Use specific profile
export AWS_PROFILE=myprofile
```

### State Lock Errors

```
Error: Error acquiring the state lock
```

Solution:

```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>

# Check locks
terraform state list
```

### Provider Not Found

```
Error: Could not find installed plugin
```

Solution:

```bash
# Reinitialize to download plugins
terraform init

# Force redownload
terraform init -upgrade
```

### Import Errors

```bash
# Cannot import non-existent resource
# Verify resource exists
aws ec2 describe-instances --instance-ids i-1234567890abcdef0
```

## Debugging with Logs

```bash
# Enable debug logging
set TF_LOG=DEBUG

# Save to file
set TF_LOG_PATH=terraform.log
terraform plan > plan.log 2>&1

# View logs
type terraform.log

# Disable logging
set TF_LOG=
```

## Debugging Strategies

### 1. Validate Configuration

```bash
terraform validate
terraform fmt -check -recursive
```

### 2. Check Plan Before Apply

```bash
terraform plan -out=tfplan
terraform show tfplan
```

### 3. Check State

```bash
terraform state list
terraform state show resource_type.name
terraform state pull > state.json
```

### 4. Test Incremental Changes

```bash
# Apply one resource at a time
terraform apply -target=aws_instance.web

# Then apply others
terraform apply -target=aws_security_group.web
```

### 5. Enable Detailed Errors

```bash
# Get detailed stack trace
TF_LOG=TRACE terraform plan

# Filter specific errors
TF_LOG=TRACE terraform plan | grep -i error
```

## Troubleshooting Examples

### Issue: Circular Dependency

```
Error: Cycle: aws_security_group.app -> aws_instance.app
```

Solution: Check resource references and fix circular dependencies using `depends_on`.

### Issue: Type Mismatch

```
Error: Unsupported argument type
```

Solution: Check variable types and ensure values match declarations.

### Issue: Resource Timeout

```
Error: Resource creation timeout exceeded
```

Solution: Increase timeout in resource settings or investigate provider issues.

## Lab: Debug Problematic Configuration

1. Create configuration with intentional errors
2. Identify error from Terraform output
3. Use debug logging to analyze issue
4. Fix configuration
5. Verify with terraform validate

---

Estimated Time: 2-3 hours
