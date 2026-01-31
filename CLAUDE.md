# CLAUDE.md

tnmt.info の AWS インフラを Terraform で管理するリポジトリ。

## ローカル実行

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## ファイル構成

| ファイル | 内容 |
|---------|------|
| `main.tf` | Provider (ap-northeast-1 + us-east-1), backend (S3) |
| `cloudfront.tf` | CloudFront ディストリビューション + OAC + rewrite 関数 |
| `s3.tf` | サイト用 S3 バケット (`tnmt-info-site`) |
| `assets.tf` | アセット用 S3 バケット (`tnmt-info-assets`) + アップロード用 IAM ユーザー |
| `acm.tf` | ACM 証明書 (`tnmt.info`) |
| `route53.tf` | DNS レコード (A + AAAA) |
| `iam.tf` | GitHub Actions OIDC + IAM ロール (サイトデプロイ + インフラ CI) |
| `variables.tf` | 変数定義 |
| `outputs.tf` | 出力値 |
| `functions/rewrite.js` | CloudFront Function (ディレクトリリクエストに index.html を付与) |

## 主要リソース

| リソース | 識別子 |
|---------|--------|
| CloudFront | `E1QY925HPOX8ZS` (Free プラン, WAF 付き) |
| サイト S3 | `tnmt-info-site` |
| アセット S3 | `tnmt-info-assets` |
| アップロード用 IAM ユーザー | `tnmt-info-assets-uploader` |
| サイトデプロイ用 IAM ロール | `tnmt-info-github-actions` |
| インフラ CI 用 IAM ロール | `tnmt-info-infra-github-actions` |
| Route53 ゾーン | `Z1ANCL5HGATQ2B` |

## CI/CD

main push で GitHub Actions が `terraform plan` + `terraform apply` を実行。PR では `terraform plan` のみ。

## 注意事項

- CloudFront の Free プランは Terraform 未対応。プラン変更は AWS コンソールから行う。
- Free プランは legacy cache settings (`forwarded_values`) を使えない。`cache_policy_id` を使う。
