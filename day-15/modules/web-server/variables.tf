# Web Server Module - Input Variables
# Module May chu Web - Bien dau vao

variable "server_name" {
  description = "Name of the web server"
  type        = string
}

variable "port" {
  description = "Port number for the web server"
  type        = number
  default     = 80

  validation {
    condition     = var.port > 0 && var.port < 65536
    error_message = "Port must be between 1 and 65535"
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "document_root" {
  description = "Document root directory"
  type        = string
  default     = "/var/www/html"
}
