terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_kms_key" "s3_images_key" {
  description = "KMS key for S3 images bucket"
}

resource "aws_kms_alias" "s3_images_key_alias" {
  name          = "alias/s3-images-key"
  target_key_id = aws_kms_key.s3_images_key.id
}

data "aws_caller_identity" "current" {}


module "s3_images" {
  source      = "./modules/s3_images"
  bucket_name = "s3-images-${random_string.suffix.result}"
  environment = "dev"
  kms_key_id  = aws_kms_key.s3_images_key.id
}

module "s3_website" {
  source                = "./modules/s3_website"
  bucket_name           = "s3-website-${random_string.suffix.result}"
  environment           = "dev"
  image_bucket_name     = module.s3_images.bucket_name
  aws_access_key_id     = var.aws_access_key
  aws_secret_access_key = var.aws_secret_key

}

module "cloudfront" {
  source                      = "./modules/cloudfront"
  website_bucket_domain_name  = module.s3_website.bucket_regional_domain_name
  images_bucket_domain_name   = module.s3_images.bucket_regional_domain_name
  origin_access_identity_path = module.s3_website.origin_access_identity_path
  website_bucket_id           = module.s3_website.bucket_id
  image_bucket_id             = module.s3_images.bucket_id
}

module "iam" {
  source                     = "./modules/iam"
  bucket_name                = module.s3_website.bucket_id
  bucket_arn                 = module.s3_website.bucket_arn
  images_bucket_name         = module.s3_images.bucket_id
  images_bucket_arn          = module.s3_images.bucket_arn
  origin_access_identity_id  = module.s3_website.origin_access_identity_id
  cloudfront_domain_name     = module.cloudfront.cloudfront_domain_name
  website_bucket_domain_name = module.s3_website.bucket_regional_domain_name
}
