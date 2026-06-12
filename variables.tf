variable "domain" {
  description = "Site domain"
  type        = string
  default     = "tnmt.info"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token (Account: R2 Edit, Pages Edit, Workers Scripts Edit / Zone: DNS Edit)"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
  default     = "ecc27c52c6bb2bf347319b62c261c0a2"
}

variable "tnmt_info_github_repo" {
  description = "tnmt.info サイト本体リポジトリ (owner/name)"
  type        = string
  default     = "tnmt/tnmt.info"
}
