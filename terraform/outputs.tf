output "site_url" {
  value = "https://${var.domain_name}"
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.site.domain_name
}

output "bucket" {
  value = aws_s3_bucket.site.id
}
