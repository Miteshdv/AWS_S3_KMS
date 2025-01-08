variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "images_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "images_bucket_arn" {
  description = "The ARN of the S3 bucket"
  type        = string
}

variable "origin_access_identity_id" {
  description = "Origin Access Identity ID"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "Domain name of the CloudFront distribution"
  type        = string
}

variable "website_bucket_domain_name" {
  description = "Domain name of the S3 website bucket"
  type        = string
}

variable "identity_pool_id" {
  description = "Cognito Identity Pool ID"
  type        = string
}

