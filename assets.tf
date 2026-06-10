# IAM user for uploading images to the assets bucket
resource "aws_iam_user" "assets_uploader" {
  name = "tnmt-info-assets-uploader"
}

resource "aws_iam_user_policy" "assets_uploader" {
  name = "tnmt-info-assets-upload"
  user = aws_iam_user.assets_uploader.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.assets.arn}/images/*"
      }
    ]
  })
}

# S3 bucket for uploaded assets (images etc.), served via CloudFront /images/*
resource "aws_s3_bucket" "assets" {
  bucket = "tnmt-info-assets"
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  # Public read を policy 経由で許可するため block_public_policy /
  # restrict_public_buckets を解除。ACL 系は引き続き遮断する。
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "assets" {
  bucket = aws_s3_bucket.assets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowImageUpload"
        Effect    = "Allow"
        Principal = { AWS = aws_iam_user.assets_uploader.arn }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.assets.arn}/images/*"
      },
      {
        Sid       = "AllowPublicReadImages"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.assets.arn}/images/*"
      },
      {
        Sid       = "AllowCloudFrontSite"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.assets.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.site.arn
          }
        }
      }
    ]
  })
}

