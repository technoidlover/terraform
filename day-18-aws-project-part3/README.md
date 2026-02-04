# Day 18: AWS Project Part 3 - Database and Monitoring

Database layer, logging, and monitoring infrastructure.

## Key Components

1. RDS Multi-AZ Database
2. DB Subnet Group
3. Parameter Groups
4. CloudWatch Logs
5. SNS Topics for Alerts

## Implementation

See main.tf for:
- Multi-AZ RDS MySQL database
- Backup and retention policies
- Parameter group customization
- CloudWatch monitoring
- SNS notification setup
- Database outputs and connection strings

## Deployment

To deploy complete infrastructure:

```bash
cd day-16-aws-project-part1
terraform apply

cd ../day-17-aws-project-part2
terraform apply

cd ../day-18-aws-project-part3
terraform apply
```

## Clean Up

```bash
# Destroy in reverse order
cd day-18-aws-project-part3
terraform destroy

cd ../day-17-aws-project-part2
terraform destroy

cd ../day-16-aws-project-part1
terraform destroy
```

---

Estimated Time: 3-4 hours
