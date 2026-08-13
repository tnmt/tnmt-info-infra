output "web_analytics_site_token" {
  description = "Cloudflare Web Analytics beacon token (data-cf-beacon 用)"
  value       = cloudflare_web_analytics_site.site.site_token
}
