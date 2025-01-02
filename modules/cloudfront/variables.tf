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
