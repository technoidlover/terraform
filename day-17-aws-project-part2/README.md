# Day 17: AWS Project Part 2 - Application Tier

Load balancer and auto-scaling group configuration for the application tier.

## Key Components

1. Application Load Balancer
2. Target Groups
3. Launch Template
4. Auto Scaling Group
5. Health Checks

## Implementation

See main.tf in this directory for:
- ALB with multiple target groups
- Health check configuration
- Launch template with user data
- Auto Scaling Group with policies
- CloudWatch alarms
- Complete outputs for connecting to other components

## Architecture

The application tier receives traffic from ALB and scales based on CPU utilization.

---

Estimated Time: 4 hours
