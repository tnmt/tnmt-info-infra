# R2 bucket: tnmt.info の画像配信元。
# Pages Functions binding 経由で配信するため public access は付けない。
resource "cloudflare_r2_bucket" "assets" {
  account_id = var.cloudflare_account_id
  name       = "tnmt-info-assets"
  location   = "APAC"
}

# R2 bucket: Terraform state backend (AWS S3 backend からの移行先)。
resource "cloudflare_r2_bucket" "terraform_state" {
  account_id = var.cloudflare_account_id
  name       = "tnmt-info-terraform-state"
  location   = "APAC"
}

# Pages project: tnmt/tnmt.info を GitHub 連携でビルド・配信。
# 初回のみ Cloudflare ダッシュボードで GitHub authorize が必要。
resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = "tnmt-info"
  production_branch = "main"

  source = {
    type = "github"
    config = {
      owner                         = split("/", var.tnmt_info_github_repo)[0]
      repo_name                     = split("/", var.tnmt_info_github_repo)[1]
      production_branch             = "main"
      pr_comments_enabled           = true
      production_deployment_enabled = true
      preview_deployment_setting    = "all"
    }
  }

  build_config = {
    build_command   = "hugo --gc --minify"
    destination_dir = "public"
    root_dir        = ""
  }

  # env_vars (HUGO_VERSION) のみ Terraform 管理。
  # r2_buckets / compatibility_date は wrangler.toml が真実 (provider v5 の
  # r2_buckets シリアライズバグ回避: cloudflare/terraform-provider-cloudflare#5373)。
  deployment_configs = {
    production = {
      env_vars = {
        HUGO_VERSION = { type = "plain_text", value = "0.155.0" }
      }
    }
    preview = {
      env_vars = {
        HUGO_VERSION = { type = "plain_text", value = "0.155.0" }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      deployment_configs.production.r2_buckets,
      deployment_configs.preview.r2_buckets,
      deployment_configs.production.compatibility_date,
      deployment_configs.preview.compatibility_date,
      source.config.path_includes,
      source.config.preview_branch_includes,
    ]
  }
}

# Pages にカスタムドメインをバインド
resource "cloudflare_pages_domain" "site" {
  account_id   = var.cloudflare_account_id
  project_name = cloudflare_pages_project.site.name
  name         = var.domain
}

# DNS レコードは Cloudflare ダッシュボードで管理 (Terraform 管理外)。
