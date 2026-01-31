# CLAUDE.md

## コマンド

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## 注意事項

- CloudFront の Free プランは Terraform 未対応。プラン変更は AWS コンソールから行う。
- Free プランは legacy cache settings (`forwarded_values`) を使えない。`cache_policy_id` を使う。
- サイト本体は別リポジトリ [tnmt/tnmt.info](https://github.com/tnmt/tnmt.info)。
