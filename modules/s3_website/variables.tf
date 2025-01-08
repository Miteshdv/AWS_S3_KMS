variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment for the S3 bucket (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "image_bucket_name" {
  description = "The name of the S3 bucket for images"
  type        = string
}


variable "user_pool_id" {
  description = "Cognito User Pool ID"
  type        = string
}

variable "user_pool_web_client_id" {
  description = "Cognito User Pool Web Client ID"
  type        = string
}

variable "identity_pool_id" {
  description = "Cognito Identity Pool ID"
  type        = string
}
