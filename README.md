# tnmt-info-infra

[tnmt.info](https://tnmt.info/) の AWS インフラを Terraform で管理するリポジトリ。

## 構成

| ファイル | 内容 |
|---------|------|
| `main.tf` | Provider (ap-northeast-1 + us-east-1), backend (S3) |
| `cloudfront.tf` | CloudFront ディストリビューション + OAC + rewrite 関数 |
| `s3.tf` | サイト用 S3 バケット (`tnmt-info-site`) |
| `assets.tf` | アセット用 S3 バケット (`tnmt-info-assets`) + アップロード用 IAM ユーザー |
| `acm.tf` | ACM 証明書 (`tnmt.info`) |
| `route53.tf` | DNS レコード (A + AAAA) |
| `iam.tf` | GitHub Actions OIDC + IAM ロール |
| `variables.tf` | 変数定義 |
| `outputs.tf` | 出力値 |
| `functions/rewrite.js` | CloudFront Function (ディレクトリリクエストに index.html を付与) |

## 主要リソース

| リソース | 識別子 |
|---------|--------|
| CloudFront | `E2GN36ZTBGUALZ` (pay-as-you-go, WAF なし) |
| サイト S3 | `tnmt-info-site` |
| アセット S3 | `tnmt-info-assets` |
| アップロード用 IAM ユーザー | `tnmt-info-assets-uploader` |
| サイトデプロイ用 IAM ロール | `tnmt-info-github-actions` |
| インフラ CI 用 IAM ロール | `tnmt-info-infra-github-actions` |
| Route53 ゾーン | `Z1ANCL5HGATQ2B` |

## 画像アップロード

日記画像のアップロードには `tnmt-info-assets-uploader` IAM ユーザーを使う。

```sh
AWS_PROFILE=tnmt-info-assets-uploader python3 scripts/upload_diary_image.py photo.jpg --date 2026-01-30 --alt "説明文"
```

アップロードスクリプトは [tnmt.info](https://github.com/tnmt/tnmt.info) リポジトリの `scripts/upload_diary_image.py`。

## ローカル実行

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## CI/CD

main push で GitHub Actions が `terraform plan` + `terraform apply` を実行。PR では `terraform plan` のみ。

## 注意事項

- CloudFront は pay-as-you-go で運用する。WAF は関連付けない。
- 旧 Free プラン distribution `E1QY925HPOX8ZS` は無効化済み。pricing plan を AWS コンソールでキャンセル後、月次請求サイクル終了後に削除する。
