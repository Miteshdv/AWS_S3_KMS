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
}

module "s3_images" {
  source      = "./modules/s3_images"
  bucket_name = "s3-images-${random_string.suffix.result}"
  environment = "dev"
}

module "s3_website" {
  source            = "./modules/s3_website"
  bucket_name       = "s3-website-${random_string.suffix.result}"
  environment       = "dev"
  image_bucket_name = module.s3_images.bucket_name
}

module "cloudfront" {
  source                      = "./modules/cloudfront"
  website_bucket_domain_name  = module.s3_website.bucket_regional_domain_name
  images_bucket_domain_name   = module.s3_images.bucket_regional_domain_name
  origin_access_identity_path = module.s3_website.origin_access_identity_path
}

module "iam" {
  source                    = "./modules/iam"
  bucket_name               = module.s3_website.bucket_id
  bucket_arn                = module.s3_website.bucket_arn
  images_bucket_name        = module.s3_images.bucket_id
  images_bucket_arn         = module.s3_images.bucket_arn
  origin_access_identity_id = module.s3_website.origin_access_identity_id
}

