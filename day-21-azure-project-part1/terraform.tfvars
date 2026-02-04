# Day 21: Terraform Variables - Azure VMs and Networking

subscription_id     = "YOUR_SUBSCRIPTION_ID"
location            = "East US"
app_name            = "my-app"
environment         = "dev"
vnet_cidr           = "10.0.0.0/16"
subnet_cidr         = "10.0.1.0/24"
vm_count            = 2
vm_size             = "Standard_B2s"
admin_username      = "azureuser"
ssh_public_key_path = "~/.ssh/id_rsa.pub"
db_password         = "ChangeMe@123456"
alert_email         = "admin@example.com"
