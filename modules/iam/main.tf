resource "aws_s3_bucket_policy" "images_bucket_policy" {
  bucket = var.images_bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${var.images_bucket_arn}",
          "${var.images_bucket_arn}/*"
        ]
        Condition = {
          StringLike = {
            "aws:Referer" : [
              "https://${var.cloudfront_domain_name}/*"
            ]
          }
        }
      }
    ]
  })
}


resource "aws_iam_policy" "image_bucket_access" {
  name        = "ImageBucketAccessPolicy"
  description = "Access policy for specific role or user"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect"   = "Allow",
        "Action"   = ["s3:ListBucket"],
        "Resource" = "${var.images_bucket_arn}"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"

        ],
        Resource = "${var.images_bucket_arn}/*",
      },
    ],
  })
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = var.bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.origin_access_identity_id}"
        },
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::674541888232:user/Mitesh_admin"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_policy" "bucket_access" {
  name        = "BucketAccessPolicy"
  description = "Access policy for specific role or user"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = "${var.bucket_arn}/*",
      },
    ],
  })
}


resource "aws_iam_role_policy_attachment" "attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.bucket_access.arn
}

resource "aws_iam_role_policy_attachment" "image_attachment" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.image_bucket_access.arn
}


resource "aws_s3_bucket_cors_configuration" "images_bucket_cors" {
  bucket = var.images_bucket_name

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
