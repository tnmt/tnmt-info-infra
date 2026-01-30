variable "domain" {
  description = "Site domain"
  type        = string
  default     = "tnmt.info"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for site hosting"
  type        = string
  default     = "tnmt-info-site"
}

variable "github_repo" {
  description = "GitHub repository (owner/repo)"
  type        = string
  default     = "tnmt/tnmt.info"
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for tnmt.info"
  type        = string
}

variable "vps_ip" {
  description = "VPS IP address (used until CloudFront cutover)"
  type        = string
  default     = "164.70.114.34"
}
