# tnmt-info-infra

[tnmt.info](https://tnmt.info/) の Cloudflare リソースを Terraform で管理するリポジトリ。

## 構成

| ファイル | 内容 |
|---------|------|
| `main.tf` | Provider (cloudflare), backend (Cloudflare R2 を S3 互換 API で) |
| `cloudflare.tf` | R2 bucket / Pages project / Pages domain |
| `variables.tf` | 変数定義 |

## 主要リソース

| リソース | 識別子 |
|---------|--------|
| 画像配信 R2 バケット | `tnmt-info-assets` |
| Terraform state 用 R2 バケット | `tnmt-info-terraform-state` |
| Pages project | `tnmt-info` (GitHub: `tnmt/tnmt.info`, Hugo extended 0.155.0) |

DNS は Cloudflare ダッシュボードで管理 (Terraform 管理外)。

## 画像アップロード

日記画像のアップロードは R2 アクセスキーで実行。
`~/.aws/credentials` に `tnmt-info-assets-uploader` プロファイルを作っておく。

```sh
AWS_PROFILE=tnmt-info-assets-uploader python3 scripts/upload_diary_image.py photo.jpg --date 2026-01-30 --alt "説明文"
```

アップロードスクリプトは [tnmt.info](https://github.com/tnmt/tnmt.info) リポジトリの `scripts/upload_diary_image.py`。
配信は Pages Functions (`functions/images/[[path]].ts`) が R2 バケットから返す。

## ローカル実行

```sh
terraform plan
terraform apply
```

backend は `~/.aws/credentials` の `tnmt-info-terraform-state` プロファイルを内部参照する。
Cloudflare provider 認証は `terraform.tfvars` の `cloudflare_api_token`。

## CI/CD

main push で GitHub Actions が `terraform plan` + `terraform apply` を実行。PR では `terraform plan` のみ。
必要な GitHub Secrets:

- `CLOUDFLARE_API_TOKEN`
- `R2_STATE_ACCESS_KEY_ID`
- `R2_STATE_SECRET_ACCESS_KEY`
