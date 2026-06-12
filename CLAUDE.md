# CLAUDE.md

## コマンド

```sh
terraform plan
terraform apply
```

backend は `~/.aws/credentials` の `tnmt-info-terraform-state` profile を内部参照する (Cloudflare R2 を S3 互換 API で利用)。

## 注意事項

- サイト本体は別リポジトリ [tnmt/tnmt.info](https://github.com/tnmt/tnmt.info)。Cloudflare Pages で配信。
- `/images/*` は Cloudflare R2 バケット `tnmt-info-assets` を Pages Functions (`functions/images/[[path]].ts`) 経由で配信。
- DNS は Cloudflare ダッシュボードで管理 (Terraform 管理外)。
- Pages の R2 binding (`IMAGES`) と `compatibility_date` は tnmt.info リポの `wrangler.toml` で管理。`env_vars` (HUGO_VERSION) は Terraform 管理。

