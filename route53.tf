resource "aws_route53_record" "site" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "site_aaaa" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "three_min_static" {
  zone_id = var.route53_zone_id
  name    = "3min-static.tnmt.info"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.three_min_static.domain_name
    zone_id                = aws_cloudfront_distribution.three_min_static.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "static" {
  zone_id = var.route53_zone_id
  name    = "static.tnmt.info"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static.domain_name
    zone_id                = aws_cloudfront_distribution.static.hosted_zone_id
    evaluate_target_health = false
  }
}
