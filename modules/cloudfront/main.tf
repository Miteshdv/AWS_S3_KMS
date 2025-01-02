resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = var.website_bucket_domain_name
    origin_id   = var.website_bucket_id
    s3_origin_config {
      origin_access_identity = var.origin_access_identity_path
    }
  }

  origin {
    domain_name = var.images_bucket_domain_name
    origin_id   = var.image_bucket_id

    s3_origin_config {
      origin_access_identity = var.origin_access_identity_path
    }
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id = var.website_bucket_id

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  ordered_cache_behavior {
    path_pattern     = "images/*"
    target_origin_id = var.image_bucket_id

    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }


    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
