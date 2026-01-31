# S3 bucket for uploaded assets (images etc.), served via CloudFront /images/*
resource "aws_s3_bucket" "assets" {
  bucket = "tnmt-info-assets"
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "assets" {
  bucket = aws_s3_bucket.assets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowImageUpload"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::540104841974:user/3min-static-tnmt-info" }
        Action    = "s3:PutObject"
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

