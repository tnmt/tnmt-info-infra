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
  default     = "Z1ANCL5HGATQ2B"
}

variable "site_origin_ipv4" {
  description = "IPv4 address of the self-hosted nginx serving tnmt.info"
  type        = string
  default     = "160.251.120.174"
}
