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
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::540104841974:distribution/E1E01I6MZ0YN6E"
          }
        }
      },
      {
        Sid       = "S3PolicyStmt-DO-NOT-MODIFY-1742223404452"
        Effect    = "Allow"
        Principal = { Service = "logging.s3.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.static.arn}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "540104841974"
          }
        }
      },
      {
        Sid       = "AWSLogDeliveryWrite1671744880"
        Effect    = "Allow"
        Principal = { Service = "delivery.logs.amazonaws.com" }
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.static.arn}/AWSLogs/540104841974/CloudFront/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "540104841974"
            "s3:x-amz-acl"     = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:us-east-1:540104841974:delivery-source:CreatedByCloudFront-E1E01I6MZ0YN6E"
          }
        }
      },
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static.arn}/*"
        Condition = {
          ArnLike = {
            "AWS:SourceArn" = "arn:aws:cloudfront::540104841974:distribution/E3CO5VDV5CAN87"
          }
        }
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

# CloudFront Origin Access Controls
resource "aws_cloudfront_origin_access_control" "three_min_static" {
  name                              = "3min-static-tnmt-info.s3.ap-northeast-1.amazonaws.com"
  description                       = "3min-static-tnmt-info"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_origin_access_control" "static" {
  name                              = "oac-3min-static-tnmt-info.s3.ap-northeast-1.amazonaw-ml0lqg7jk2y"
  description                       = "Created by CloudFront"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFront distribution for 3min-static.tnmt.info
resource "aws_cloudfront_distribution" "three_min_static" {
  origin {
    domain_name              = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id                = "3min-static-tnmt-info.s3.ap-northeast-1.amazonaws.com"
    origin_access_control_id = aws_cloudfront_origin_access_control.three_min_static.id
  }

  enabled         = true
  aliases         = ["3min-static.tnmt.info"]
  is_ipv6_enabled = false
  http_version    = "http2and3"
  price_class     = "PriceClass_All"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "3min-static-tnmt-info.s3.ap-northeast-1.amazonaws.com"
    viewer_protocol_policy = "allow-all"
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.wildcard.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# CloudFront distribution for static.tnmt.info
resource "aws_cloudfront_distribution" "static" {
  origin {
    domain_name              = aws_s3_bucket.static.bucket_regional_domain_name
    origin_id                = "3min-static-tnmt-info.s3.ap-northeast-1.amazonaws.com-ml0lpxpsa3f"
    origin_access_control_id = aws_cloudfront_origin_access_control.static.id
  }

  enabled         = true
  aliases         = ["static.tnmt.info"]
  is_ipv6_enabled = true
  http_version    = "http2"
  price_class     = "PriceClass_All"
  web_acl_id      = "arn:aws:wafv2:us-east-1:540104841974:global/webacl/CreatedByCloudFront-076588ed/7a7c8fd8-cb79-41e2-81da-56cbfc4eb5c3"

  tags = {
    Name = "static.tnmt.info"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "3min-static-tnmt-info.s3.ap-northeast-1.amazonaws.com-ml0lpxpsa3f"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.wildcard.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
