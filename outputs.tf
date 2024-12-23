output "s3_website_bucket_url" {
  value = "http://${module.s3_website.bucket_regional_domain_name}"
}

output "cloudfront_distribution_url" {
  value = "https://${module.cloudfront.cloudfront_domain_name}"
}
