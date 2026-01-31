# S3 bucket for static assets (shared by 3min-static and static distributions)
resource "aws_s3_bucket" "static" {
  bucket = "3min-static-tnmt-info"
}

resource "aws_s3_bucket_public_access_block" "static" {
  bucket = aws_s3_bucket.static.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static" {
  bucket = aws_s3_bucket.static.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "1"
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::540104841974:user/3min-static-tnmt-info" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.static.arn}/images/*"
      },
      {
        Sid       = "AllowCloudFrontSite"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.site.arn
          }
        }
      }
    ]
  })
}

