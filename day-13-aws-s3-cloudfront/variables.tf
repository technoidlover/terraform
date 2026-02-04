# Day 13: AWS S3 and CloudFront - Variables

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cloudfront_enabled" {
  description = "Enable CloudFront distribution"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "index_html_content" {
  description = "HTML content for index.html"
  type        = string
  default     = <<-EOT
    <!DOCTYPE html>
    <html>
    <head>
        <title>Day 13 - S3 and CloudFront</title>
    </head>
    <body>
        <h1>Welcome to Day 13!</h1>
        <p>This is a static website hosted on S3 and distributed via CloudFront.</p>
    </body>
    </html>
  EOT
}
