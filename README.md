# tnmt-info-infra

[tnmt.info](https://tnmt.info/) の AWS リソースを Terraform で管理するリポジトリ。

## 構成

| ファイル | 内容 |
|---------|------|
| `main.tf` | Provider (ap-northeast-1 + us-east-1), backend (S3) |
| `assets.tf` | 画像 S3 バケット (`tnmt-info-assets`) + アップロード用 IAM ユーザー |
| `route53.tf` | `tnmt.info` の A レコード |
| `iam.tf` | GitHub Actions OIDC + インフラ CI 用 IAM ロール |
| `variables.tf` | 変数定義 |
| `outputs.tf` | 出力値 |

## 主要リソース

| リソース | 識別子 |
|---------|--------|
| アセット S3 | `tnmt-info-assets` |
| アップロード用 IAM ユーザー | `tnmt-info-assets-uploader` |
| インフラ CI 用 IAM ロール | `tnmt-info-infra-github-actions` |
| Route53 ゾーン | `Z1ANCL5HGATQ2B` |

## 画像アップロード

日記画像のアップロードには `tnmt-info-assets-uploader` IAM ユーザーを使う。

```sh
AWS_PROFILE=tnmt-info-assets-uploader python3 scripts/upload_diary_image.py photo.jpg --date 2026-01-30 --alt "説明文"
```

アップロードスクリプトは [tnmt.info](https://github.com/tnmt/tnmt.info) リポジトリの `scripts/upload_diary_image.py`。
配信は nginx 側で `/images/*` を `tnmt-info-assets` へ reverse proxy する。

## ローカル実行

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## CI/CD

main push で GitHub Actions が `terraform plan` + `terraform apply` を実行。PR では `terraform plan` のみ。
