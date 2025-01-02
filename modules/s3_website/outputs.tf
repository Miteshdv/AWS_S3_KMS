output "bucket_id" {
  value = aws_s3_bucket.static_website.id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.static_website.bucket_regional_domain_name
}

output "bucket_name" {
  value = aws_s3_bucket.static_website.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.static_website.arn
}

output "origin_access_identity_id" {
  value = aws_cloudfront_origin_access_identity.s3_oai.id
}

output "origin_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.s3_oai.cloudfront_access_identity_path
}


output "origin_access_identity_arn" {
  value = aws_cloudfront_origin_access_identity.s3_oai.iam_arn
}
