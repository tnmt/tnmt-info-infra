resource "aws_route53_record" "site" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"
  ttl     = 300
  records = [var.site_origin_ipv4]
}
