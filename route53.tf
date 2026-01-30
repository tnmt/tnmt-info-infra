# 切り替え時に alias ブロックに変更して apply する
# alias {
#   name                   = aws_cloudfront_distribution.site.domain_name
#   zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
#   evaluate_target_health = false
# }
resource "aws_route53_record" "site" {
  zone_id = var.route53_zone_id
  name    = var.domain
  type    = "A"
  ttl     = 300
  records = [var.vps_ip]
}

# 切り替え時に有効化する
# resource "aws_route53_record" "site_aaaa" {
#   zone_id = var.route53_zone_id
#   name    = var.domain
#   type    = "AAAA"
#
#   alias {
#     name                   = aws_cloudfront_distribution.site.domain_name
#     zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
#     evaluate_target_health = false
#   }
# }
