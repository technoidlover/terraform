#!/bin/bash
# User data script for EC2 instances
set -x
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Update system
apt-get update
apt-get upgrade -y

# Install packages
apt-get install -y \
    curl \
    wget \
    git \
    vim \
    htop \
    net-tools

# Create a marker file
echo "Environment: ${environment}" > /var/www/html/environment.txt
echo "Initialized at $(date)" >> /var/www/html/environment.txt

# Install web server
apt-get install -y nginx
systemctl start nginx
systemctl enable nginx

echo "User data execution completed"
