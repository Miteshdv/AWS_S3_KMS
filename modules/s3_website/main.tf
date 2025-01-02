data "template_file" "index_html" {
  template = file("${path.module}/index.html.tpl")

  vars = {
    bucket_name           = var.image_bucket_name
    aws_access_key_id     = var.aws_access_key_id
    aws_secret_access_key = var.aws_secret_access_key
  }
}

resource "aws_s3_bucket" "static_website" {
  bucket = var.bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = true
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "static_website" {
  bucket                  = aws_s3_bucket.static_website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = aws_s3_bucket.static_website.bucket
  key          = "index.html"
  content      = data.template_file.index_html.rendered
  content_type = "text/html"
}

resource "aws_cloudfront_origin_access_identity" "s3_oai" {
  comment = "Origin Access Identity for S3 bucket"
}

