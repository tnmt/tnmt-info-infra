# tnmt-info-infra

[tnmt.info](https://tnmt.info/) の周辺 AWS リソースを Terraform で管理するリポジトリ。
サイト本体は self-hosted nginx へ移行済で、ここに残っているのは画像配信用の
assets バケット、画像アップロード用 IAM、DNS レコード、インフラ CI 用ロール等。

## 構成

| ファイル | 内容 |
|---------|------|
| `main.tf` | Provider (ap-northeast-1 + us-east-1), backend (S3) |
| `assets.tf` | 画像 S3 バケット (`tnmt-info-assets`) + アップロード用 IAM ユーザー |
| `route53.tf` | DNS A レコード (`tnmt.info` → self-hosted origin) |
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
配信は nginx 側で `/images/*` を `tnmt-info-assets` へ reverse proxy している。

## ローカル実行

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## CI/CD

main push で GitHub Actions が `terraform plan` + `terraform apply` を実行。PR では `terraform plan` のみ。

## 注意事項

- サイト本体は self-hosted nginx 配信に移行済 (2026-06-10)。CloudFront / サイト用 S3 / ACM 証明書 / サイトデプロイ用 IAM ロールは削除済。
- 旧 Free プラン distribution `E1QY925HPOX8ZS` は 2026-06-10 に削除済み。
- 旧 Free プラン Web ACL `CreatedByCloudFront-2ee1e91b` は 2026-06-10 に削除済み。
