variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
  default     = "user-pool"
}

variable "identity_pool_name" {
  description = "Name of the Cognito Identity Pool"
  type        = string
  default     = "identity-pool"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "image_bucket_name" {
  description = "Name of the S3 bucket for images"
  type        = string
}
