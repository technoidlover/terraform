# Using the Web Server Module
# Su dung Module May chu Web

terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Call the web server module for development
# Goi module may chu web cho moi truong development
module "dev_server" {
  source = "./modules/web-server"

  server_name   = "dev-web-server"
  port          = 8080
  environment   = "dev"
  document_root = "/var/www/dev"
}

# Call the web server module for production
# Goi module may chu web cho moi truong production
module "prod_server" {
  source = "./modules/web-server"

  server_name   = "prod-web-server"
  port          = 80
  environment   = "prod"
  document_root = "/var/www/prod"
}

# Output values from modules
# Gia tri output tu cac module
output "dev_server_url" {
  description = "Development server URL"
  value       = module.dev_server.server_url
}

output "prod_server_url" {
  description = "Production server URL"
  value       = module.prod_server.server_url
}

output "all_servers" {
  description = "All server information"
  value = {
    development = {
      name = module.dev_server.server_name
      port = module.dev_server.server_port
      url  = module.dev_server.server_url
    }
    production = {
      name = module.prod_server.server_name
      port = module.prod_server.server_port
      url  = module.prod_server.server_url
    }
  }
}
