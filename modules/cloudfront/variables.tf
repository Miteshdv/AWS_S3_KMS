variable "website_bucket_domain_name" {
  description = "The domain name of the S3 bucket for the website"
  type        = string
}

variable "images_bucket_domain_name" {
  description = "The domain name of the S3 bucket for images"
  type        = string
}

variable "origin_access_identity_path" {
  description = "The CloudFront origin access identity path"
  type        = string
}

variable "website_bucket_id" {
  description = "website bucket id"
}


variable "image_bucket_id" {
  description = "image bucket id"
}

variable "cognito_identity_pool_id" {
  description = "ID of the Cognito Identity Pool"
  type        = string
}

variable "authenticated_role_arn" {
  description = "ARN of the authenticated role"
  type        = string
}

variable "unauthenticated_role_arn" {
  description = "ARN of the unauthenticated role"
  type        = string
}

variable "cognito_user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "cognito_region" {
  description = "Cognito Region"
  type        = string
}

variable "app_client_id" {
  description = "App Client ID"
  type        = string
}


