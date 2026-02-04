# Simple Web Server Module - Main Configuration
# Module May chu Web Don gian - Cau hinh Chinh

terraform {
  required_version = ">= 1.0"
}

# Create a configuration file for the web server
# Tao file cau hinh cho may chu web
resource "local_file" "server_config" {
  filename = "${path.module}/server-${var.server_name}.conf"
  content  = <<-EOT
    Server Configuration
    Cau hinh May chu
    ====================
    
    Server Name: ${var.server_name}
    Ten May chu: ${var.server_name}
    
    Port: ${var.port}
    Cong: ${var.port}
    
    Environment: ${var.environment}
    Moi truong: ${var.environment}
    
    Document Root: ${var.document_root}
    Thu muc Tai lieu: ${var.document_root}
  EOT
}

# Create an index file
# Tao file index
resource "local_file" "index" {
  filename = "${path.module}/index-${var.server_name}.html"
  content  = <<-EOT
    <!DOCTYPE html>
    <html>
    <head>
        <title>${var.server_name}</title>
    </head>
    <body>
        <h1>Welcome to ${var.server_name}</h1>
        <p>Environment: ${var.environment}</p>
        <p>Port: ${var.port}</p>
    </body>
    </html>
  EOT
}
