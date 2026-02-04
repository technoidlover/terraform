# Day 13: AWS S3 and CloudFront - Outputs

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.website.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.website.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_status" {
  description = "CloudFront distribution status"
  value       = aws_cloudfront_distribution.main.status
}

output "oai_id" {
  description = "CloudFront OAI ID"
  value       = aws_cloudfront_origin_access_identity.main.id
}

output "website_url" {
  description = "CloudFront website URL"
  value       = "https://${aws_cloudfront_distribution.main.domain_name}"
}

output "s3_storage_summary" {
  description = "S3 storage configuration summary"
  value = {
    website_bucket       = aws_s3_bucket.website.id
    logs_bucket          = aws_s3_bucket.logs.id
    versioning_enabled   = true
    encryption_enabled   = true
    cloudfront_enabled   = var.cloudfront_enabled
  }
}
