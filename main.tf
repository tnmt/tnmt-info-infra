terraform {
  required_version = ">= 1.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

  # Cloudflare R2 を S3 互換 backend として使用。
  backend "s3" {
    bucket  = "tnmt-info-terraform-state"
    key     = "tnmt-info-infra/terraform.tfstate"
    region  = "auto"
    profile = "tnmt-r2-state"
    endpoints = {
      s3 = "https://ecc27c52c6bb2bf347319b62c261c0a2.r2.cloudflarestorage.com"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
