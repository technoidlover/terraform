# Web Server Module - Outputs
# Module May chu Web - Outputs

output "server_name" {
  description = "The name of the web server"
  value       = var.server_name
}

output "server_port" {
  description = "The port the server is listening on"
  value       = var.port
}

output "config_file" {
  description = "Path to the server configuration file"
  value       = local_file.server_config.filename
}

output "index_file" {
  description = "Path to the index file"
  value       = local_file.index.filename
}

output "server_url" {
  description = "URL to access the server"
  value       = "http://${var.server_name}:${var.port}"
}
